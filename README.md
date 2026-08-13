# ports-zakinko

zakinko が自作したソフトウェアの FreeBSD port 置き場。

本家 ports ツリーの `net` や `security` に直接ファイルを置かず、オーバーレイと
して重ねています。本家を更新しても自作分が消えず、どれが自作かも一目で
分かります。

pkgsrc 版は [pkgsrc-zakinko](https://github.com/zakinko/pkgsrc-zakinko) に
あります。

## 置き方

好きな場所に clone して、`/etc/make.conf` で重ねます。

```sh
git clone git@github.com:zakinko/ports-zakinko.git /usr/local/ports-zakinko
echo 'OVERLAYS+=/usr/local/ports-zakinko' >> /etc/make.conf
```

オーバーレイはカテゴリごと重なるので、本家の `net` や `security` を
置き換えることはありません。`bsd.port.mk` の類は本家のものが使われます。

オーバーレイを使わず、本家ツリーに直接置いても構いません。

```sh
cp -R /usr/local/ports-zakinko/net/nss_stns /usr/ports/net/
```

## 使い方

```sh
cd /usr/ports/net/nss_stns
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

| Port | 内容 |
| --- | --- |
| [net/nss_stns](net/nss_stns/) | STNS の名前解決スイッチモジュール |
| [security/github-keys](security/github-keys/) | GitHub に公開された SSH 鍵を sshd に渡す |
| [security/stnsd](security/stnsd/) | 小さな STNS API サーバ |

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
cp -R /usr/local/ports-zakinko/net/nss_stns /usr/dports/net/
```
