# Run code
vscode等のterminalde
でプロジェクトディレクトリ（Main.jlがある場所）に移動しjuliaを起動.

```
julia
```

shell modeに移行
```
julia> ;
```
とすると
```
shell>
```
となる．

プロジェクトディレクトリ\${PROJECT_DIR}の下に,作業ディレクトリ（${WORK_DIR}:Main.jlがある場所）と，その中に読みたい生データ（.csvで書かれている）があることを確認(後述のファイル構成の章を確認)．\${xx}はuserが設定した名前を意味．
   　
```
ls ./${WORK_DIR}
```
などとすると
```
${filename}.csv
```
が見られるはず（shell modeで通常のshell scriptが使える）．

pkgモードに入る
```
julia> ] #Pkg mode
```

幾つかのパッケージをインストールする
```
(@v1.x)pkg> add Plots, Statistics, Printf, DelimitedFiles
```

実行する
```
include("Main.jl")
```

---
## 環境のセットアップ
1. juliaをインストール(URL: https://julialang.org/ )　
   > 参考：https://zenn.dev/ohno/articles/cf2b4d09d4480e

2. 好みのeditorがなければ，vscodeがおすすめ
   > 参考:https://qtech-blog.com/detail/julia-install-vscode/

   > https://www.julia-vscode.org/

3. juliaの環境に必要なライブラリをインストールする．
   1. terminal で juliaとする.
   2. keyboardの "]"のキーをおし，pkgモードに入る．
   3. ```add Plots, Printf, Statistics```とすると，Plots, Printf, Statisticsの３つのライブラリがインストールされる．（その他実行して，xxというライブラリがありませんとエラーを吐いたら同様にインストールする．)

4. engine-checkmanのコード一式をgithubからinstallする．(以下のどちらかの方法で)
   - 自分のPCにgit clone

   - githubのページの緑ボタン（Code)を押してダウンロード
---


## このコードの使い方
1. stdinを確認（入力変数の説明あり）(通常stdinは標準入力の意味だがこのコードではjuliaの関数になってる)
    > windowsとmac(linux)でpathの書き方が違うので注意
    >>Mac：/usr/document/hoge.txt

    >>windows:\\user\\document\\hoge.txt

2. Main.jlを実行
    vscodeなら，左のメニューバーの”Extension"から"julia"で検索したときに出てくるパッケージ*Julia*(julialangが提供)をinstallすると，エディタ画面の右上の三角マークから実行できる．（他にも色々）

    エディタによらず実行する場合は，みなさんのterminalから"Main.jl"があるディレクトリで，
    ```
    julia Main.jl
    ```
    もしくは
    ```
    julia
    include("./Main.jl")
    ```
    とする．

---
## このコードは何をするか
1. ロガーが出力するcsv fileからデータを読む
2. 最大推力や作動時間を計算する
3. スラストカーブをかく．pdfなどでファイル保存．

---
## ファイル構成
>ファイルの位置関係は保つこと
- Project folder
  - functions(いろんな機能の関数)
    - engine_property.jl
    - find_stem_and_max.jl
    - math.jl
    - plots_thrust.jl
    - read_data.jl
    - variables.jl（グローバル変数をここで定義しているので，参照すると良い）
  - $workdir (stdin中のinput.workdirに対応)
      - "xxx".csv
      - (ここにスラストカーブの画像などが出力される)
  - Main.jl
  - stdin
  - Readme
---

## コードを読む際のヘルプ
1.  *plots_thrust.jl*などでは，juliaの多重ディスパッチという機能を使っています．これは，同じ関数の名前だけど，引数の型や数の違いによって処理を変更できるような機能です．
  >> (参考）https://dsng.hatenablog.com/entry/2014/01/27/173154

  >> (参考)　https://docs.julialang.org/en/v1/manual/methods/

---


## 発展の余地
1. シミュ用のデータを書き出すコードを追加（生データのままだとシミュが不安定になるので，スラストデータを移動平均するなど）
  
2. 推力以外にも圧力や温度センサーのデータを処理するコードへ変更
   1. variables.jl
   2. read_data.jl
   3. stdin
3. 作動時間計算用のコードを改良
   1. find_stem_and_max.jl

