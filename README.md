# ports-zakinko

zakinko が自作したソフトウェアの FreeBSD port 置き場。

本家 ports ツリーの `net` や `security` に混ぜず、`zakinko` という独立した
カテゴリとして切っています。本家を更新しても自作分が消えず、どれが自作かも
一目で分かります。pkgsrc 版は
[pkgsrc-zakinko](https://github.com/zakinko/pkgsrc-zakinko) にあり、そちらと
同じ形にしてあります。

## 置き方

このリポジトリを `/usr/ports/zakinko` として配置します。

```sh
git clone git@github.com:zakinko/ports-zakinko.git /usr/ports/zakinko
```

すでに ports ツリーを git で管理していて中に別リポジトリを置きたくない場合は、
別の場所に clone してオーバーレイとして重ねてください。

```sh
git clone git@github.com:zakinko/ports-zakinko.git /usr/local/ports-zakinko
echo 'OVERLAYS+=/usr/local/ports-zakinko' >> /etc/make.conf
```

ただしオーバーレイはカテゴリごと重なるので、この場合リポジトリの中身は
`/usr/local/ports-zakinko/zakinko/` に置き直す必要があります。素直なのは
前者です。

**どちらの場合も `/etc/make.conf` に一行足してください。**

```sh
echo 'VALID_CATEGORIES+=zakinko' >> /etc/make.conf
```

`bsd.port.mk` の `check-sanity` が `CATEGORIES` を本家のカテゴリ一覧と
突き合わせるので、これが無いと `zakinko` は「不正なカテゴリ」として弾かれます。
pkgsrc にこれに当たるものは無く、ディレクトリさえあれば通ります。

## 使い方

```sh
cd /usr/ports/zakinko/nss_stns
make install clean
```

配布物のチェックサムを追跡していない port は、初回に生成します。

```sh
make makesum
```

送り出す前には、stage して packing list を実際の install 結果と
突き合わせておきます。

```sh
make stage
make check-plist
make package
```

## 収録 port

| Port | 第二カテゴリ | 内容 |
| --- | --- | --- |
| [github-keys](github-keys/) | `security` | GitHub に公開された SSH 鍵を sshd に渡す |
| [nss_stns](nss_stns/) | `net` | STNS の名前解決スイッチモジュール |
| [stnsd](stnsd/) | `security` | 小さな STNS API サーバ |

第二カテゴリは本家に投げるときの置き場所です。nss_stns が `net` で
github-keys が `security` なのは、前者がディレクトリのクライアントなのに対し、
後者は誰がログインしてよいかを決めるものだからです。

## net/nss_stns が `@postexec` を持っている理由

libc は `dlopen("nss_stns.so.1")` を裸の名前で呼び、set-user-ID の
プログラムに対して ld.so は `/lib` と `/usr/lib` しか探しません。そのため
モジュールへの symlink が `/usr/lib` に要ります。無いと `su(1)` や `login(1)`
が STNS のアカウントを黙って引けなくなります。

`/usr/lib` は `PREFIX` の外で、`make stage` の対象になりません。そこで port は
`NSSLIBDIR=${PREFIX}/lib` でビルドして upstream の `make install` が張る
symlink を止め、`pkg-plist` の `@postexec` / `@postunexec` から張っています。

## DragonFly (DPorts)

DPorts 用のディレクトリは意図的に置いていません。DPorts は FreeBSD ports に
[DeltaPorts](https://github.com/DragonFlyBSD/DeltaPorts) の差分を重ねて
*生成* されるものなので、port は FreeBSD に投げれば次の生成で DPorts に
降りてきます。DragonFly だけが必要とする差分だけが DeltaPorts の仕事です。

ここの port はどれも DragonFly で重ねる差分がないため、DPorts ツリーに
そのまま置いて動きます。

```sh
git clone git@github.com:zakinko/ports-zakinko.git /usr/dports/zakinko
echo 'VALID_CATEGORIES+=zakinko' >> /etc/make.conf
```
