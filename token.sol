pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    uint256 private constant BURN_PERCENT = 10;
    uint8 private _decimals;

    constructor(string memory name, string memory symbol,uint8 _dec) ERC20(name, symbol) {
        _decimals = _dec;
        //_mint(msg.sender, 1000000000000000000000 * 10** decimals());
    }

    function mint(address to, uint amount) external {
        _mint(to, amount);
    }

    /*
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 burnAmount = (amount * BURN_PERCENT) / 100;
        _burn(msg.sender, burnAmount);
        _transfer(msg.sender, recipient, amount - burnAmount);
        return true;
    }
    */


    function decimals() public view override returns (uint8) {
        return _decimals;
    }

}
