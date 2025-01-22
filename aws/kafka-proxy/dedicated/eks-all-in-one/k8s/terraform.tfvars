regional_endpoint = "dedicated.apse1.confluent.justinrlee.io"
zonal_endpoint = {
  "apse1-az1" = "dedicated-apse1-az1.apse1.confluent.justinrlee.io"
  "apse1-az2" = "dedicated-apse1-az2.apse1.confluent.justinrlee.io"
  "apse1-az3" = "dedicated-apse1-az3.apse1.confluent.justinrlee.io"
}
# zone_broker_offsets = {
#   "az1" = 1
#   "az2" = 0
#   "az3" = 2
# }
zones = [
  "apse1-az2",
  "apse1-az1",
  "apse1-az3",
]
target_groups = {
  "apse1-az1-10001" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10001/35791e93182289a9"
    "port" = "10001"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10004" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10004/c271f9bdc1681d31"
    "port" = "10004"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10007" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10007/31689fffb8cbe1ef"
    "port" = "10007"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10010" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10010/68345fe0b89b4de0"
    "port" = "10010"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10013" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10013/025f92c02e9a3515"
    "port" = "10013"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10016" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10016/dc904498ffc948a4"
    "port" = "10016"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10019" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10019/907f30b6c1d8d08c"
    "port" = "10019"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10022" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10022/198b532e3eb96044"
    "port" = "10022"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10025" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10025/fba193920501dda6"
    "port" = "10025"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10028" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10028/eee63957a4aaefe5"
    "port" = "10028"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10031" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10031/d414dae8b51dd6ef"
    "port" = "10031"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10034" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10034/7660636b3e42f97b"
    "port" = "10034"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10037" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10037/8b94738594e33159"
    "port" = "10037"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10040" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10040/deac74ff52609b5e"
    "port" = "10040"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10043" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10043/7dcf26ff8d365830"
    "port" = "10043"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10046" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10046/e96a34ca7126a486"
    "port" = "10046"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10049" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10049/e54fdb6904a00c41"
    "port" = "10049"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10052" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10052/9af16daeadc50106"
    "port" = "10052"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10055" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10055/f3f18133bbccb97a"
    "port" = "10055"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10058" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10058/d56198183f8e5149"
    "port" = "10058"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10061" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10061/5e23d8b973b454f1"
    "port" = "10061"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10064" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10064/68173b194e0c7fd2"
    "port" = "10064"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10067" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10067/21faa78ab4b0e4af"
    "port" = "10067"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10070" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10070/7c3ef284340b63a2"
    "port" = "10070"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10073" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10073/7d0adab64c915a2e"
    "port" = "10073"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10076" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10076/333a4bf40130856f"
    "port" = "10076"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10079" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10079/cb20bbd4ec7d6fb2"
    "port" = "10079"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10082" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10082/dc4001cd1b6487ac"
    "port" = "10082"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10085" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10085/25978ab2911ec6f6"
    "port" = "10085"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10088" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10088/5dbf02a404929580"
    "port" = "10088"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10091" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10091/d4de5ddd6d30dc2d"
    "port" = "10091"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10094" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10094/9fb173dde789770e"
    "port" = "10094"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10097" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10097/4be521f4e28c3194"
    "port" = "10097"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10100" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10100/8095d634539c67ae"
    "port" = "10100"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10103" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10103/556c5aa4d182ad1b"
    "port" = "10103"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10106" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10106/d72192294ffe9ca1"
    "port" = "10106"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10109" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10109/58be561a18d6de67"
    "port" = "10109"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10112" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10112/360cf18f6c0ccec6"
    "port" = "10112"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10115" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10115/c683e9f7d01188a7"
    "port" = "10115"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10118" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10118/6eabfafa8df250cf"
    "port" = "10118"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10121" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10121/2e917fa63846affd"
    "port" = "10121"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10124" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10124/482c0457ea432463"
    "port" = "10124"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10127" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10127/a1597cdb01d8c316"
    "port" = "10127"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10130" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10130/99ab62b6eebf27e1"
    "port" = "10130"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10133" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10133/a92d4bc10b1f4b2b"
    "port" = "10133"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10136" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10136/3c6b4f62a74fad85"
    "port" = "10136"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10139" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10139/c2ea7033c14694c8"
    "port" = "10139"
    "zone" = "apse1-az1"
  }
  "apse1-az1-10142" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-1-10142/6f338fcb11e9ad8d"
    "port" = "10142"
    "zone" = "apse1-az1"
  }
  "apse1-az1-9092" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-az1-bs/50e4a0755b7d60d8"
    "port" = "9092"
    "zone" = "apse1-az1"
  }
  "apse1-az2-10000" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10000/b7179f465f413436"
    "port" = "10000"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10003" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10003/33876b8dae4a15d0"
    "port" = "10003"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10006" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10006/1e3e235c942236b4"
    "port" = "10006"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10009" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10009/08977c4fc1b8652f"
    "port" = "10009"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10012" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10012/42ba415cec29f3c0"
    "port" = "10012"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10015" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10015/126b53464eeeaee0"
    "port" = "10015"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10018" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10018/2ede34d7c40b1c6b"
    "port" = "10018"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10021" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10021/a8ce3d0fa1be20ce"
    "port" = "10021"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10024" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10024/9b7c9888cd04eda6"
    "port" = "10024"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10027" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10027/a6ef38cf837a0a81"
    "port" = "10027"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10030" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10030/959d65eaa1a74d64"
    "port" = "10030"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10033" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10033/1424ea6583be25a6"
    "port" = "10033"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10036" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10036/5c997a25a47474ab"
    "port" = "10036"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10039" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10039/4c94cf24fed687ac"
    "port" = "10039"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10042" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10042/7a5557fd78d148e7"
    "port" = "10042"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10045" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10045/5f606657e43e351f"
    "port" = "10045"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10048" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10048/c1e44b1b2f00f82a"
    "port" = "10048"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10051" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10051/e8d239189b6f06d6"
    "port" = "10051"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10054" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10054/3e0f84e24eb06212"
    "port" = "10054"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10057" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10057/7ebec7d4841b4c2a"
    "port" = "10057"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10060" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10060/f35e93c4af1cf6ec"
    "port" = "10060"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10063" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10063/59abacdd5432485e"
    "port" = "10063"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10066" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10066/571e6aa05f80017e"
    "port" = "10066"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10069" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10069/2972c3fe47d5ed96"
    "port" = "10069"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10072" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10072/f47a21ffa3d63438"
    "port" = "10072"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10075" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10075/3d5d6b2b86e05dbc"
    "port" = "10075"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10078" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10078/c8d379311dcff3be"
    "port" = "10078"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10081" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10081/78144ba39a3e5d0d"
    "port" = "10081"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10084" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10084/e6fac8f92ec71c34"
    "port" = "10084"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10087" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10087/877a57a0098ca287"
    "port" = "10087"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10090" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10090/f85e2f1a5dd6531e"
    "port" = "10090"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10093" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10093/65f44ae0073d01b7"
    "port" = "10093"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10096" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10096/628a017eef85485d"
    "port" = "10096"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10099" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10099/96a5cf126ccd3bf2"
    "port" = "10099"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10102" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10102/73911e3f74fa6b1b"
    "port" = "10102"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10105" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10105/baf2d11b02102f38"
    "port" = "10105"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10108" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10108/7671eb8084a03c42"
    "port" = "10108"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10111" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10111/0a745b2699cca549"
    "port" = "10111"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10114" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10114/7f7e8ef4418f07ea"
    "port" = "10114"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10117" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10117/00650faddbc27525"
    "port" = "10117"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10120" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10120/2e55fc83c0c9783c"
    "port" = "10120"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10123" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10123/ee7cfac20903d360"
    "port" = "10123"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10126" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10126/0f99cf50ebe69176"
    "port" = "10126"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10129" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10129/4fa48d0f66612e4c"
    "port" = "10129"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10132" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10132/13c2eae58228a6b0"
    "port" = "10132"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10135" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10135/c28c7ac1e37bd502"
    "port" = "10135"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10138" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10138/ed3f6676b12e417b"
    "port" = "10138"
    "zone" = "apse1-az2"
  }
  "apse1-az2-10141" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-2-10141/d7742135aba18c76"
    "port" = "10141"
    "zone" = "apse1-az2"
  }
  "apse1-az2-9092" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-az2-bs/8f9b72d94f5e54ab"
    "port" = "9092"
    "zone" = "apse1-az2"
  }
  "apse1-az3-10002" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10002/4d10af210568b2b2"
    "port" = "10002"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10005" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10005/899bb19a2daf65bc"
    "port" = "10005"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10008" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10008/3497eb775058f190"
    "port" = "10008"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10011" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10011/159214da8c61e28a"
    "port" = "10011"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10014" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10014/0b155e0b48970b25"
    "port" = "10014"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10017" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10017/a7bc7759d7174ea5"
    "port" = "10017"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10020" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10020/ba0b4de329577451"
    "port" = "10020"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10023" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10023/4c211868c1a52af7"
    "port" = "10023"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10026" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10026/7747163df6c62fa1"
    "port" = "10026"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10029" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10029/1d6ec51eaeabdecf"
    "port" = "10029"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10032" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10032/0332938ab5e146a4"
    "port" = "10032"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10035" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10035/8c1961d9d3b51aee"
    "port" = "10035"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10038" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10038/1f34866775b534e9"
    "port" = "10038"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10041" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10041/4e088c9ef761a35c"
    "port" = "10041"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10044" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10044/3ed6b5eb746234c8"
    "port" = "10044"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10047" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10047/63323ddffb121874"
    "port" = "10047"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10050" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10050/1bf6f11a40b24886"
    "port" = "10050"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10053" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10053/dd0a260e3c6c30ff"
    "port" = "10053"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10056" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10056/37c25c28a34751d4"
    "port" = "10056"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10059" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10059/698e5969780ddd39"
    "port" = "10059"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10062" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10062/a630ec1672661b2d"
    "port" = "10062"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10065" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10065/3a999fc84565d0d1"
    "port" = "10065"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10068" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10068/eabdb3b1305541fc"
    "port" = "10068"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10071" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10071/6ce840fe7d5ea426"
    "port" = "10071"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10074" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10074/a52ccada677e8e45"
    "port" = "10074"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10077" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10077/b4db10cedc87647e"
    "port" = "10077"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10080" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10080/06497ed8147dce4c"
    "port" = "10080"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10083" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10083/b687dc9e375d00dd"
    "port" = "10083"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10086" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10086/f106d7be20ab6e65"
    "port" = "10086"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10089" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10089/63e0fdf8cca4b127"
    "port" = "10089"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10092" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10092/6f6be3e930532585"
    "port" = "10092"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10095" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10095/1f9af989cc09655b"
    "port" = "10095"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10098" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10098/0f32294683fa5539"
    "port" = "10098"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10101" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10101/24cd3377000791f4"
    "port" = "10101"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10104" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10104/0f22c47d4dfa6742"
    "port" = "10104"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10107" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10107/b5478b2f2d7e8a46"
    "port" = "10107"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10110" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10110/7bf26e9c4f774a89"
    "port" = "10110"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10113" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10113/3523ee905d7e1787"
    "port" = "10113"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10116" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10116/b24d3c30079bf7e2"
    "port" = "10116"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10119" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10119/20519f9b90cb2bc4"
    "port" = "10119"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10122" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10122/118c19c1bea9f2d9"
    "port" = "10122"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10125" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10125/653c37ebe27115f2"
    "port" = "10125"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10128" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10128/ac11af0708884bc7"
    "port" = "10128"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10131" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10131/7a9ae72e5a8366d6"
    "port" = "10131"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10134" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10134/8f62323a0eb5fca3"
    "port" = "10134"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10137" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10137/b89699da2c59f72c"
    "port" = "10137"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10140" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10140/42907f2b9bfb48c0"
    "port" = "10140"
    "zone" = "apse1-az3"
  }
  "apse1-az3-10143" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-3-10143/03d4513a8248d6e8"
    "port" = "10143"
    "zone" = "apse1-az3"
  }
  "apse1-az3-9092" = {
    "arn" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:targetgroup/justin-kp-eks-az3-bs/613358baf7663795"
    "port" = "9092"
    "zone" = "apse1-az3"
  }
}