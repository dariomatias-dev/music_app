# Changelog

## [0.2.0](https://github.com/dariomatias-dev/music_app/compare/music_app-v0.1.0...music_app-v0.2.0) (2026-09-04)


### Features

* **branding:** add the app launcher icon ([de90eb2](https://github.com/dariomatias-dev/music_app/commit/de90eb2c212e8f305cecbe9ed2540ed2ba6ce555))
* **database:** seed a development library ([31c2d8c](https://github.com/dariomatias-dev/music_app/commit/31c2d8c2f4746ea276566cce784dcc6b7c5924a4))
* **database:** seed lyrics and excluded folders ([9aca7cb](https://github.com/dariomatias-dev/music_app/commit/9aca7cbc778b99673fbeef5d9967e9420139fa1b))
* **permissions:** request the notification permission ([1aa83ca](https://github.com/dariomatias-dev/music_app/commit/1aa83caedba6cacd1205dba1d2416d2fd87bf49c))
* **settings:** surface a blocked playback notification ([643c580](https://github.com/dariomatias-dev/music_app/commit/643c580ef94831464f982ae0793aebb9a1f0487f))
* **storage:** let the user forget tracks whose files are gone ([1022f01](https://github.com/dariomatias-dev/music_app/commit/1022f01fdced844e551c422c831bb76a5bf8b90c))


### Bug Fixes

* **ci:** regenerate on every verify run ([44ed972](https://github.com/dariomatias-dev/music_app/commit/44ed972d9c3bde08285904ed9adb2feca1c2b980))
* **database:** enforce foreign keys and cascade track deletes ([dba259a](https://github.com/dariomatias-dev/music_app/commit/dba259a8ef8d5524e3ab7fb6eea46abc04d96651))
* **history:** write the play in progress out when backgrounded ([dc74f2d](https://github.com/dariomatias-dev/music_app/commit/dc74f2db8861490dba959e086dc66e782846251d))
* **library:** leave out albums and artists with nothing left ([00660a0](https://github.com/dariomatias-dev/music_app/commit/00660a077598ca7a958637a46a80b9f9f3b84edb))
* **queue:** save the session before the app can be killed ([35b8b12](https://github.com/dariomatias-dev/music_app/commit/35b8b123aa422ef6169181b9faa3f3367823645f))
* **release:** move last-release-sha to the top of the config ([11f5cda](https://github.com/dariomatias-dev/music_app/commit/11f5cda8240eb362efbad871dc1e5c3c0f007e09))
* **statistics:** count streak days by the calendar ([83491eb](https://github.com/dariomatias-dev/music_app/commit/83491ebea21e0dd5bc61eed6afdb816d876206f7))
* **storage:** apply the settings an imported backup restores ([012a748](https://github.com/dariomatias-dev/music_app/commit/012a74861e84e6696e562a12c8d0d1d048a0fdac))
* **storage:** commit the regenerated storage view model ([dfc9dbc](https://github.com/dariomatias-dev/music_app/commit/dfc9dbc30153a729d48eccabe2365f0ca1398529))


### Performance Improvements

* **app_ui:** decode embedded cover art at the size it is drawn ([10b8518](https://github.com/dariomatias-dev/music_app/commit/10b8518f5c9c407c8c3f3692e309c747601532ed))
* **library:** read artists and albums once per scan ([b0ec31f](https://github.com/dariomatias-dev/music_app/commit/b0ec31fe9ef25adc3979bc7313da8b18c9014bbd))
* **ui:** subscribe to one MediaQuery aspect instead of all of them ([4bb5f4b](https://github.com/dariomatias-dev/music_app/commit/4bb5f4b5e4567f1033fb68c2e1a900e531d90352))
