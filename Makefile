#
# zakinko の自作パッケージを置くローカルカテゴリ。
# 本家 ports ツリーと混ざらないように、独立したカテゴリとして切っている。
#
# zakinko は本家の VALID_CATEGORIES に無いので、/etc/make.conf で足すこと。
# 詳しくは README.md を見てほしい。
#

    COMMENT = Local ports maintained by zakinko

    SUBDIR += github-keys
    SUBDIR += nss_stns
    SUBDIR += stnsd

.include <bsd.port.subdir.mk>
