# labo/ansible について

kubernetesクラスタ & DNSサーバ & gitlab & gluster 等をansibleで初期構築するplaybookです。

# 実行方法

1. dockerが実行可能な環境を作成します。

2. レポじとりをクローンし、カレントディレクトリをansibleディレクトリに移動、docker buildします。  
    ```sh
    cd ~/labo/ansible
    docker build -t ansible .
    ```
3. 必要な設定を作成・入力します。

- `hosts.yaml`・`server-csr.json`をカスタマイズ  
- group_vars内に`all.yaml`を作成して必要な変数を入力（`all.yaml.example`を参照）  
- `roles/bind9/files`にbind9ゾーン情報を記載した`named.zone`を配置  
- `ansible/roles/kubernetes/configure/files/glusterfs-endpoint.yaml`にglusterfs-serverのエンドポイントを記述

4. docker runでrun.shを実行します。
    ```sh
    docker run --rm -v ~/.ssh:/root/.ssh -v ${PWD}:/root/ansible -it ansible ./run.sh
    ```

# 初期化

`./roles/kubernetes/build/files/pki`ディレクトリを削除します。
```sh
cd ~/labo/ansible
rm -vfr ./roles/kubernetes/build/files/pki
rm -v ./admin.conf
```