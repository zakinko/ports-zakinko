PORTNAME=	github-keys
DISTVERSIONPREFIX=	v
DISTVERSION=	0.1.0
CATEGORIES=	security

MAINTAINER=	zakinko@snowrabbit.org
COMMENT=	Serve a user's published GitHub SSH keys to sshd
WWW=		https://github.com/zakinko/github-keys

LICENSE=	BSD2CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

RUN_DEPENDS=	curl:ftp/curl

USE_GITHUB=	yes
GH_ACCOUNT=	zakinko

# The upstream Makefile is BSD make, so it is driven directly.
MAKE_ARGS=	PREFIX=${PREFIX} \
		LOCALBASE=${LOCALBASE} \
		SYSCONFDIR=${PREFIX}/etc

NO_ARCH=	yes
TEST_TARGET=	test

.include <bsd.port.mk>
