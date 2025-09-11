# panels_md5.sh
# Base de données des hash DTB → Nom de panel

declare -Ag dtb_md5=(
  ["bfc6068ef7d80575bef04b36ef881619"]="R36S Original Panel 0"
  
  ["a3d55922b4ccce3e2b23c57cefdd9ba7"]="R36S Original Panel 1"
  ["28792e1126f543279237ec45de5c03e5"]="R36S Original Panel 1"
  ["3869152c5fb8e5c0e923f7f00e42231e"]="R36S Original Panel 1"

  ["a5d6f30491abac29423d0c1334ad88d3"]="R36S Original Panel 2"
  ["2d82650c523ac734a16bddf600286d6d"]="R36S Original Panel 2"
  ["daf777a6b5ed355c3aaf546da4e42da9"]="R36S Original Panel 2"

  ["b3bf18765a4453b8eaeaf60362b79b3d"]="R36S Original Panel 3"
  ["f6984db1b07f03a90c182c59dd51ccf0"]="R36S Original Panel 3"
  ["543038f0cc9b515401186ebbde232cfa"]="R36S Original Panel 3"
  ["9f41df45acac67bff88ec52306efc225"]="R36S Original Panel 3"
  ["72856dd54e77a0fd61d9c2a59b08b685"]="R36S Original Panel 3"
  ["040b5bfff8c1969aaeedcfbe8a33ad06"]="R36S Original Panel 3"

  ["7b76c4e4333887fd0ccc0afddd2f41ce"]="R36S Original Panel 4"
  ["4863e7544738df62eaae4a1bec031fd9"]="R36S Original Panel 4"
  ["5871fde00d2ed1e5866665e38ee3cfab"]="R36S Original Panel 4"
  ["b92e8d791dec428b65ad52ccc5a17af4"]="R36S Original Panel 4"
  ["8faf0a3873008548c55dfff574b2a3f9"]="R36S Original Panel 4"
  ["c4547ce22eca3c318546f3cbf5f3d878"]="R36S Original Panel 4"
  ["42a3021377abadd36375e62a7d5a2e40"]="R36S Original Panel 4"
  ["5c4793e33d3fac217bb5b5e90fd6a45f"]="R36S Original Panel 4"

  ["861278f7ab7ade97ac1515aedbbdeff0"]="R36S Original Panel 5"

  ["2a79e4190f205868b14f6c3db836f23e"]="R36S Original Panel 6"
  
  ["f4e351095d367b641054413e1c3c7a62"]="Clone K36 Panel 1 (2TF)"
  ["3173d0f7326d03b021c729ed2d8ae5a1"]="Clone K36 Panel 1 (v2)"
  ["71d96e48f8d6f1ae3e184c34023747b3"]="Clone K36 Panel 4"
  ["320555247f7e911cb5c8e1ef7899776e"]="Clone K36S"
  ["9782673a1f17f559a62ee210d4bbf206"]="Clone K36S"
  
  ["3d7f16bbd611f88ee9b0eb10791eadfc"]="Clone R36 Max"
  ["82f93e50285b7dfbb7ab05a133c2812b"]="Clone R36 Max"
  ["3101828659a9256f3bfc70631ba58dfc"]="Clone R36 Max"
  
  ["6de588c4eda969c2487402a4823ca60a"]="Clone R36 Pro"
  ["2748ec226bcd9c06095bb94c4637493a"]="Clone R36 Pro"

  ["ff983f16c0dbc18ab97116cc3677f559"]="Clone R36 Plus"
  
  ["f8f7f0cdc410543bfa6a43b7e369ff11"]="Clone R36 Ultra"
  ["5cb5429b5418aa71b730501786578d04"]="Clone R36 Ultra"
  ["1837a4e5ff70b6022cf2661d8c77477d"]="Clone R36 Ultra v2"
  
  ["ccc295fcb58c947bbc3026d153eae978"]="Clone R36T"
  
  ["fae7b5ce300a4ce5122d09d292dbf1eb"]="Clone RX6H"
  ["ec92c33f55913a9681f1abc4210b8926"]="Clone RX6H Panel 1"
  ["0b11a2bf3a862dbb0e16ae6cd8b8b228"]="Clone RX6H Panel 2"
  
  ["85b04dcfef99b097ce5de45c39a94778"]="Clone RX6S"
  ["a4c3d2881898f1c3ab976d8d049a4dfa"]="Clone RX6S"

  ["fdfd9918251599322d9c734629b52b5a"]="Clone R36S Panel 1"
  ["bd2e29ab7c1fdf9a40066821b6f61549"]="Clone R36S Panel 1"
  ["df50e4c1847859cc94f7e6d3e4951e15"]="Clone R36S Panel 1"
  ["3173d0f7326d03b021c729ed2d8ae5a1"]="Clone R36S Panel 1 v2"

  ["c063209abc99cb31638daf66952af4db"]="Clone R36S Panel 2"

  ["cb1e59976247acff3308b185909d441b"]="Clone R36S Panel 3"
  
  ["841d930dec80abc6a9d36ab0bd0ea0c5"]="Clone R36S Panel 4"
  ["7fddf9a2c058c9e93aeb4253212cb4f7"]="Clone R36S Panel 4"
  ["5786486a43d4e757e37e6863b2924325"]="Clone R36S Panel 4"
  ["059c64824dbf92ed528880dec22a72ac"]="Clone R36S Panel 4"
  ["9153251523a603af76c4cbe0825a9580"]="Clone R36S Panel 4"

  ["31f968d5a1d000a42c82207fb7c875b7"]="Clone R36S Panel 5"
  ["5c295b222d0ec114a4fda02d40f3411b"]="Clone R36S Panel 5"
  ["c9eb94f10298a567efe0506ca07bbf66"]="Clone R36S Panel 5 or 8"
  ["06674e5e8380f25da8162716333712e4"]="Clone R36S Panel 5"
  ["88f853daa7524244ca4ce7a7da3bedbc"]="Clone R36S Panel 5"

  ["85a6f808b362c2e79ae9860b81ae6f66"]="Clone R36S Panel 6"

  ["01de1c13af2882c697e013224f40bc5b"]="Clone R36S Panel 7"

  ["2cc8f4054fe0b5db5aac45d36c46779c"]="Clone R36S Panel 8"
  ["786e294c8929e227ed60d0d9c5859b6d"]="Clone R36S Panel 8"
  ["86aa365c57fb4f8edaaca3deb3ff005b"]="Clone R36S Panel 8 ou 9"

  ["2be6f8864414af729c0666089ac3af88"]="Clone R36S Panel 9"

  ["037dfec5cb0bf9938864489fac9d9e3c"]="Clone R36S Panel 10"

  ["46d4451874ef5c8803fa053a875c9ef7"]="Clone R36S Panel 11"

  ["5a0c1d40d13d2c785e05b90161a004d0"]="Clone R36S Soy Sauce"
  ["0276a922c6206a81a67945b53c042c66"]="Clone R36S Soy Sauce"
  
)
