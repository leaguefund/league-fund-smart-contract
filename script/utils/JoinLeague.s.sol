// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../src/interfaces/ILeague.sol";
import "../../addresses.sol";

/**
 * @title DeployLeagueFactory
 * @notice A simple Foundry script to deploy the LeagueFactory_TESTNET contract.
 *
 * To run:
 *    forge script script/utils/JoinLeague.s.sol \
 *       --rpc-url sepolia \
 *       --broadcast \
 *       --sig "run(address,string)" 0x59598c408485108FeBD06a81f36d8078f01Df230 "New Team Name"
 */
contract JoinLeague is Script {
    function run(address league, string memory teamName) external {
        // 1. Load your deployer's private key from an environment variable or directly.
        //    E.g. "PRIVATE_KEY" from your shell environment (recommended).
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // 2. Start broadcasting (publishing) transactions using the loaded private key.
        vm.startBroadcast(deployerPrivateKey);

        // 3. Approving USDC and starting new Season on League.
        ILeague.SeasonData memory currentSeason = ILeague(league).currentSeason();
        uint256 dues = currentSeason.dues;
        IERC20(ADDRESSES.USDC).approve(league, dues);
        ILeague(league).joinSeason(teamName);

        console.log("Joined League:", league, "with team name:", teamName);

        // 4. Stop broadcasting.
        vm.stopBroadcast();
    }
}
