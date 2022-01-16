# EVE Indy Watch Changelog

# [2.3.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v2.2.1...v2.3.0) (2022-01-16)


### Features

* sso redirect ([#50](https://github.com/bokoboshahni/eve-indy-watch/issues/50)) ([0144a77](https://github.com/bokoboshahni/eve-indy-watch/commit/0144a77052499ff204fde4930c3d9c88398ac8a1))

## [2.2.1](https://github.com/bokoboshahni/eve-indy-watch/compare/v2.2.0...v2.2.1) (2022-01-16)


### Bug Fixes

* link webpack correctly in docker-compose environments ([#49](https://github.com/bokoboshahni/eve-indy-watch/issues/49)) ([1f9f0aa](https://github.com/bokoboshahni/eve-indy-watch/commit/1f9f0aaf82372d0911c3ea20dd98095622d971d7))

# [2.2.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v2.1.2...v2.2.0) (2022-01-16)


### Features

* make prometheus opt-in instead of opt-out ([#46](https://github.com/bokoboshahni/eve-indy-watch/issues/46)) ([6c8b659](https://github.com/bokoboshahni/eve-indy-watch/commit/6c8b659dbe19d68eae2a154524e18833adc6ffce))

## [2.1.2](https://github.com/bokoboshahni/eve-indy-watch/compare/v2.1.1...v2.1.2) (2022-01-16)


### Bug Fixes

* load stations from moons properly ([#47](https://github.com/bokoboshahni/eve-indy-watch/issues/47)) ([d21b115](https://github.com/bokoboshahni/eve-indy-watch/commit/d21b11565178fcd05199cc1f34373ce992f33a9f))

## [2.1.1](https://github.com/bokoboshahni/eve-indy-watch/compare/v2.1.0...v2.1.1) (2022-01-16)


### Bug Fixes

* ensure all snapshot keys are expired ([#45](https://github.com/bokoboshahni/eve-indy-watch/issues/45)) ([4885e2f](https://github.com/bokoboshahni/eve-indy-watch/commit/4885e2f2bd373074ba8bcfb2414f5ba9fe95fc62))

# [2.1.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v2.0.0...v2.1.0) (2022-01-16)


### Features

* docker-compose dev environment ([#44](https://github.com/bokoboshahni/eve-indy-watch/issues/44)) ([719710f](https://github.com/bokoboshahni/eve-indy-watch/commit/719710fad9aaed2a9638513b1dc37afade4aaa8c))

# [2.0.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.9.0...v2.0.0) (2022-01-16)


### Features

* decommission timescaledb ([#43](https://github.com/bokoboshahni/eve-indy-watch/issues/43)) ([8da1d48](https://github.com/bokoboshahni/eve-indy-watch/commit/8da1d4855a0cd01eeadd00b4ea0d1c0758c76b8e)), closes [#33](https://github.com/bokoboshahni/eve-indy-watch/issues/33)


### BREAKING CHANGES

* remove usage of timescaledb completely

# [1.9.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.8.0...v1.9.0) (2022-01-16)


### Features

* move report runs to primary db ([#42](https://github.com/bokoboshahni/eve-indy-watch/issues/42)) ([82ab92a](https://github.com/bokoboshahni/eve-indy-watch/commit/82ab92a2e3f940149ad1c11c626eb482b16784c8))

# [1.8.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.7.0...v1.8.0) (2022-01-16)


### Features

* move region type histories to primary db ([#39](https://github.com/bokoboshahni/eve-indy-watch/issues/39)) ([b7b955a](https://github.com/bokoboshahni/eve-indy-watch/commit/b7b955a1222c3ecc57daf6d155e1e25c89b1c962))

# [1.7.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.6.0...v1.7.0) (2022-01-16)


### Features

* move ahoy to primary db ([#38](https://github.com/bokoboshahni/eve-indy-watch/issues/38)) ([1dd1e1a](https://github.com/bokoboshahni/eve-indy-watch/commit/1dd1e1a63071a5410d7ea16ed17654f88ada2217))

# [1.6.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.5.0...v1.6.0) (2022-01-16)


### Features

* procurement order delivery workflow ([#37](https://github.com/bokoboshahni/eve-indy-watch/issues/37)) ([6bbffb4](https://github.com/bokoboshahni/eve-indy-watch/commit/6bbffb4c4b1d4c855f0d7441015ad7c18f8d6a5c))

# [1.5.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.4.1...v1.5.0) (2022-01-15)


### Features

* stock levels in primary db ([#35](https://github.com/bokoboshahni/eve-indy-watch/issues/35)) ([41452bd](https://github.com/bokoboshahni/eve-indy-watch/commit/41452bd62d8675be9b3200a93a541a105c5d2afe))

## [1.4.1](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.4.0...v1.4.1) (2022-01-14)


### Bug Fixes

* remove bad api call ([#34](https://github.com/bokoboshahni/eve-indy-watch/issues/34)) ([de9f204](https://github.com/bokoboshahni/eve-indy-watch/commit/de9f20452ebef4bbca0ce1626f2e0a02739f4095))

# [1.4.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.3.4...v1.4.0) (2022-01-14)


### Features

* add visibility to procurement orders ([#29](https://github.com/bokoboshahni/eve-indy-watch/issues/29)) ([dd9c7d6](https://github.com/bokoboshahni/eve-indy-watch/commit/dd9c7d6c9be4fe8d17c2e08932f4cc9d82121c6c))

## [1.3.4](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.3.3...v1.3.4) (2022-01-13)


### Bug Fixes

* procurement order ui tweaks ([#28](https://github.com/bokoboshahni/eve-indy-watch/issues/28)) ([05a29bf](https://github.com/bokoboshahni/eve-indy-watch/commit/05a29bf843a0f56c4970a16d0000632e10b339ea))

## [1.3.3](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.3.2...v1.3.3) (2022-01-13)


### Bug Fixes

* double isk ([#27](https://github.com/bokoboshahni/eve-indy-watch/issues/27)) ([4c27245](https://github.com/bokoboshahni/eve-indy-watch/commit/4c27245d26489dd7899e58d3eebbcec3f31056a2))

## [1.3.2](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.3.1...v1.3.2) (2022-01-13)


### Bug Fixes

* use alliance procurement order requester ([#25](https://github.com/bokoboshahni/eve-indy-watch/issues/25)) ([2f60576](https://github.com/bokoboshahni/eve-indy-watch/commit/2f605763215c1aab5b8625da74fa35bcabf759a8))

## [1.3.1](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.3.0...v1.3.1) (2022-01-13)


### Bug Fixes

* procurement order ui fixes ([#24](https://github.com/bokoboshahni/eve-indy-watch/issues/24)) ([dc0bede](https://github.com/bokoboshahni/eve-indy-watch/commit/dc0bedead9116ef97c796f0ae5b373d71ad9182c))

# [1.3.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.2.0...v1.3.0) (2022-01-13)


### Features

* show app version in side nav ([daa9afc](https://github.com/bokoboshahni/eve-indy-watch/commit/daa9afca6e8e8d0e806e223e637a3afdc1d59fa4))

# [1.2.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.1.1...v1.2.0) (2022-01-13)


### Features

* visual indicator of market sync healthiness ([0712050](https://github.com/bokoboshahni/eve-indy-watch/commit/0712050c8dcb901e861fd8de4480d8576dcb2361))

## [1.1.1](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.1.0...v1.1.1) (2022-01-13)


### Bug Fixes

* allow nil assignee for public contracts ([97fd3cc](https://github.com/bokoboshahni/eve-indy-watch/commit/97fd3cca0ef206ea52ea12391c9010c63bac8be0))

# [1.1.0](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.0.2...v1.1.0) (2022-01-13)


### Bug Fixes

* don't show accept button if requester is same as user character ([6750604](https://github.com/bokoboshahni/eve-indy-watch/commit/675060481b634173cab88701a441a5f58b1a9094))
* duplicate order items on create ([b119323](https://github.com/bokoboshahni/eve-indy-watch/commit/b119323f412e48d213dae6c193e9f4764d9a6949))


### Features

* banner for delivered orders ([acf6b63](https://github.com/bokoboshahni/eve-indy-watch/commit/acf6b638aa2b2a2716bd3923fbe5d889cfaafcb2))
* modal for draft delete button ([e2cc1d5](https://github.com/bokoboshahni/eve-indy-watch/commit/e2cc1d54a8b3c53d6fefaf298122359ade05282f))
* procurement orders mvp ([385f0e3](https://github.com/bokoboshahni/eve-indy-watch/commit/385f0e3b2527b4fc8ab16c3dd0a4d8e5d9d478c0))

## [1.0.2](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.0.1...v1.0.2) (2022-01-13)


### Bug Fixes

* missing variable ([0c0292a](https://github.com/bokoboshahni/eve-indy-watch/commit/0c0292a1c012b7640545f5061ee244dd2edcc93d))

## [1.0.1](https://github.com/bokoboshahni/eve-indy-watch/compare/v1.0.0...v1.0.1) (2022-01-13)


### Bug Fixes

* block argument ([bc3358a](https://github.com/bokoboshahni/eve-indy-watch/commit/bc3358a6f425ef10638a215e399aca3127003faf))
* class not module ([b6d6b41](https://github.com/bokoboshahni/eve-indy-watch/commit/b6d6b41dafa6e4ac10378127ed3a38609dd6af3a))

# 1.0.0 (2022-01-12)

* initial release from private proof-of-concept
