$Groups = Get-MsolGroup -MaxResults 5000

foreach($g in $Groups){
    if($g.DisplayName -like "*.admin"){
      $g.ObjectID
    }
}


"d07d5d29-c134-4501-9d17-f541d56bcc9a",
"7aa32872-1b48-445b-bd88-1c43bc18d000",
"73537747-c998-40c3-b128-08b43c037c64",
"e98faccb-7864-4406-bd93-923b117801e2",
"3f91d61f-dcdb-446a-946b-2261923c0e25",
"6eefb1d7-b0ba-45be-b26a-6a6164908b9d",
"78c375ad-17c4-4b7e-b8b9-d896d6395fff",
"c546ffc1-cb01-465d-ad8b-614a7738b7f2",
"bbc72ca2-6472-4bad-adf6-ddc675e15ea2",
"ef65baf2-79e6-4253-8033-044f2ef7fd1f",
"6b2d78aa-b9f2-4d51-86fc-3045007c7cdc",
"9202b7d6-b7b5-408b-a243-f31c86c6d528",
"e84b936e-eb2f-406e-967d-52175d7ced6c",
"cd344a90-35dc-4a47-971b-c408c32acc60",
"ebfc5c2a-df5f-4937-bc59-670189ea0c44",
"8c4268de-c49b-4dc3-9018-de237cd62764"