// contracts/GameItem.sol
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

pragma solidity ^0.8.0;

contract Weather is AccessControl {

    using SafeMath for uint256;

    bytes32 public constant WEATHER_ADMIN = keccak256("WEATHER_ADMIN");

    string public NAME = "Scarlet Weather Rhapsody";

    uint256 public randomNumber = 0;
    uint256 public times = 0;
    uint256 public nowWeatherId = 0;

    uint256 private ZERO = 0;

    string[] public weathers = [
        "Temperament",      // 気質
        "Sunny",            // 快晴
        "Drizzle",          // 霧雨
        "Cloudy",           // 曇天
        "Azure Sky",        // 蒼天
        "Hail",             // 雹
        "Spring Haze",      // 花曇
        "Dense Fog",        // 濃霧
        "Snow",             // 雪
        "Sunshowers",       // 天気雨
        "Sprinkle",         // 疎雨
        "Tempest",          // 風雨
        "Mountain Vapor",   // 晴嵐
        "River Mist",       // 川霧
        "Typhoon",          // 台風
        "Aurora",           // 極光
        "Scarlet Weather Rhapsody" // 緋想天
    ];

    event WeatherChanged(uint256 _times, uint256 _weatherId, string weather);

    constructor () {
        _setupRole(WEATHER_ADMIN, msg.sender);
    }

    function getWeathersLength() public view returns(uint256) {
        return weathers.length;
    }

    function getWeathersList() public view returns(string[] memory){
        return weathers;
    }

    function getWeather() public view returns(uint256 weatherId, string memory) {
        return (nowWeatherId, weathers[nowWeatherId]);
    }

    function feedNumber(uint256 _number) public onlyRole(WEATHER_ADMIN) {
        randomNumber = ZERO.add(_number);
        nowWeatherId = _number.mod(getWeathersLength()).sub(1);
        times = times.add(1);
        emit WeatherChanged(times, nowWeatherId, weathers[nowWeatherId]);
    }

}
