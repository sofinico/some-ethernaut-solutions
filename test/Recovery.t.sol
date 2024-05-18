// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, Vm} from "forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";

import {Recovery, SimpleToken} from "../src/levels/Recovery.sol";
import {RecoveryFactory} from "../src/levels/RecoveryFactory.sol";

import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

contract TestRecovery is Test, Utils {
    Ethernaut ethernaut;
    Recovery instance;

    address payable owner;
    address payable player;

    /// @notice Create level instance.
    function setUp() public {
        address payable[] memory users = createUsers(2);

        owner = users[0];
        vm.label(owner, "Owner");

        player = users[1];
        vm.label(player, "Player");

        vm.startPrank(owner);
        ethernaut = getEthernautWithStatsProxy(owner);
        RecoveryFactory factory = new RecoveryFactory();
        ethernaut.registerLevel(Level(address(factory)));
        vm.stopPrank();

        /** 
        en este caso necesito saber quién fue el deployer del token, 
        cuál fue su nonce al momento de crear el token y de esa manera 
        tenemos determinísticamente la address perdida del contrato.

        pero, ¿quién creó el token? esto es lo que más me costó descubrir, 
        así que vamos paso por paso.
         */

        /**
        @dev esto lo necesitamos cada ves que creamos una level instance.
        esta es la manera en la que se muestran al mundo las nuevas instancias.
        para más data ir a Ethernaut::createLevelInstance()
         */
        vm.recordLogs();

        /// @notice ponemos al player como sender
        vm.startPrank(player);

        /**
        como player, hacemos un llamado al contrato Ethernaut e invocamos
        a la función createLevelInstance(). 
        
        esto es lo que hacemos cuando apretamos el botón "Get new instance" 
        en el browser. acá el frontend de OZ se encarga de poner el "value" de 
        la CALL y los argumentos de la función, que en este caso es la instancia
        del contrato RecoveryFactory.

        en createLevelInstance() (recomiendo leer la implementación), Ethernaut llama a
        RecoveryFactory invocando a la función createInstance() y pasando el mismo 
        msg.value que mandó el player. también pasa el address del player como argumento
        pero no se usa en esta factory.
        
        La factory es la que se encarga de preparar el escenario y crear la instancia 
        del nivel. 
         */

        ethernaut.createLevelInstance{value: 0.001 ether}(factory);

        /**
        @dev bueno la instance address se saca de los logs de esta manera.
        recordemos que este setUp no lo hice yo sino que lo tome
        del repo oficial de ethernaut.
         */
        Vm.Log[] memory entries = vm.getRecordedLogs();
        address instanceAddress = address(
            uint160(uint256(entries[entries.length - 1].topics[2]))
        );

        /**
        @notice finalmente guardamos la instancia de Recovery en la variable instance :)

        El punto clave acá es que la instancia de Recovery es quien crea al token (es quien 
        que tiene la keyword "new"). El nonce podemos deducirlo, veamos. 
        
        Cuando arrancamos el nivel nos dicen: "A contract creator has built a very simple 
        token factory contract." El creador es la RecoveryFactory. "After deploying the 
        first token contract, the creator sent 0.001 ether to obtain more tokens."
        
        Nos dicen que es el primer token contact que se crea, por ende como:

            - el nonce arranca en 1 para los contratos;
            - el nonce en los contratos crece en 1 cada vez que el mismo contrato crea a 
            otro contrato; (*)
        
        tenemos que el nonce que estamos buscando es 1.

        (*) Esto implica que el nonce vigente de un contrato es la cantidad
            de contratos que creó menos 1; pero queda lindo para los nuevos contratos 
            porque cada uno tiene como seed el # de contrato que fue.
         */
        instance = Recovery(payable(instanceAddress));
        vm.stopPrank();
    }

    /// @notice Check the intial state of the level and enviroment.
    function testInit() public {
        vm.startPrank(player);
        assertFalse(submitLevelInstance(ethernaut, address(instance)));
    }

    /// @notice Test the solution for the level.
    function testSolve() public {
        /** 
        calculamos la dirección perdida con la info que tenemos.

        @dev me queda por ver bien cómo funciona el RLP enconding. esto lo saqué de
        https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed
         */
        address lostAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            address(instance), // creator
                            bytes1(0x01) // nonce
                        )
                    )
                )
            )
        );

        assertEq(lostAddress.balance, 0.001 ether);

        /**
        el destroy llama a SELFDESTRUCT pasando como address de recuperación de fondos al player.
         */
        SimpleToken(payable(lostAddress)).destroy(player);

        assertEq(lostAddress.balance, 0);

        vm.prank(player);
        assertTrue(submitLevelInstance(ethernaut, address(instance)));
    }
}
