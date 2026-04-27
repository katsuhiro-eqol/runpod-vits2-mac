runpodで使用するDockerfileをmacbookでビルド、デプロイすることを前提に作成
以下で実行

chmod +x build_push.sh
./build_push.sh

モデルはrunpodのNetwork Volumeに置く
/runpod-volume/
└─ models/
   └─ your_model/
      ├─ config.json
      ├─ style_vectors.npy
      ├─ model.safetensors
      └─ ...