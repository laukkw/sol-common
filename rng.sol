pragma solidity ^0.8.21;
import "v2-core/interfaces/IUniswapV2Pair.sol";
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract rng {
    using SafeMath for uint256;
    IUniswapV2Pair[] private lpList;
    
    constructor (address[] memory _lp){
        uint lens = _lp.length;
        for (uint i = 0; i < lens; i++){
            lpList.push(IUniswapV2Pair(_lp[i]));
        }
    }

    function rand(uint256 cap) external view returns(uint256){
        uint256 _rng = _addLp().add(_addChainTips());
        return _rng % cap; 
    }

    function randEth(uint256 cap) external view returns(uint256){
        uint256 _rng = _addLp().add(_addChainTips()).add(_etherChain());
        return _rng % cap; 
    }
    

    function _addLp() view internal returns(uint256){
        uint256 entropy;
        uint256 lens = lpList.length;
        for (uint i = 0;i < lens;i++){
            (uint256 reserve0, uint256 reserve1,) = lpList[i].getReserves();
            entropy = entropy.add(reserve0>reserve1?reserve0.sub(reserve1):reserve1.sub(reserve0));
        }
        return entropy;
    }

    function _addChainTips() view internal returns(uint256){
        return uint256(keccak256(abi.encodePacked(
            (block.timestamp).add
            (block.basefee).add
            ((uint256(keccak256(abi.encodePacked(block.coinbase))))
             / (block.timestamp)).add
            (block.gaslimit).add
            (block.number).add
            (uint256(keccak256(abi.encodePacked(msg.sender)))))));
    }

    function _etherChain() view internal returns(uint256){
        return uint256(keccak256(abi.encodePacked(block.prevrandao)));
    }
    
    
}
