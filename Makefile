#
# zakinko の自作ソフトウェア用 ports オーバーレイ。
# 本家 ports ツリーと混ぜず、OVERLAYS で重ねて使う。
#

    COMMENT = Ports maintained by zakinko

    SUBDIR += net
    SUBDIR += security

.include <bsd.port.subdir.mk>
