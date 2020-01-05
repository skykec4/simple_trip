class NationFlag {
  static String getNationFlagImage(String name) {
    final nationName = nation[nationList.indexOf(name)];

    return 'https://www.countryflags.io/$nationName/shiny/64.png';
  }
  static String nationNameToThreeWord(String nationName){
    final index = nationList.indexOf(nationName);
    return unit[index];
  }

  static String threeWordToNationName(String threeWord){
    final index = unit.indexOf(threeWord);
    return nationList[index];
  }
  static String nationNameToTwoWord(String nationName){
    final index = nationList.indexOf(nationName);
    return nation[index];
  }

  static int threeWordIndex(String threeWord){
    print('[[[[[[[[[[[[[ threeWordIndex : ${unit.indexOf(threeWord)}]]]]]]]]]]]]]');
    return unit.indexOf(threeWord);
  }


}

List unit = [
  "AED",
  "AUD",
  "BHD",
  "BND",
  "CAD",
  "CHF",
  "CNH",
  "DKK",
  "EUR",
  "GBP",
  "HKD",
  "IDR(100)",
  "JPY(100)",
  "KRW",
  "KWD",
  "MYR",
  "NOK",
  "NZD",
  "SAR",
  "SEK",
  "SGD",
  "THB",
  "USD"
];

List nation = [
  "AE",
  "AU",
  "BH",
  "BN",
  "CA",
  "CH",
  "CN",
  "DK",
  "EU",
  "GB",
  "HK",
  "ID",
  "JP",
  "KR",
  "KW",
  "MY",
  "NO",
  "NZ",
  "SA",
  "SE",
  "SG",
  "TH",
  "US"
];

Map nationName = {
  "AE": '아랍에미리트',
  "AU": '호주',
  "BH": '바레인',
  "BN": '브루나이',
  "CA": '캐나다',
  "CH": '스위스',
  "CN": '중국',
  "DK": '덴마크',
  "EU": '유로',
  "GB": '영국',
  "HK": '홍콩',
  "ID": '인도네시아',
  "JP": '일본',
  "KR": '한국',
  "KW": '쿠웨이트',
  "MY": '말레이시아',
  "NO": '노르웨이',
  "NZ": '뉴질랜드',
  "SA": '사우디',
  "SE": '스웨덴',
  "SG": '싱가포르',
  "TH": '태국',
  "US": '미국'
};

List nationList = [
  '아랍에미리트',
  '호주',
  '바레인',
  '브루나이',
  '캐나다',
  '스위스',
  '중국',
  '덴마크',
  '유로',
  '영국',
  '홍콩',
  '인도네시아',
  '일본',
  '한국',
  '쿠웨이트',
  '말레이시아',
  '노르웨이',
  '뉴질랜드',
  '사우디',
  '스웨덴',
  '싱가포르',
  '태국',
  '미국'
];
