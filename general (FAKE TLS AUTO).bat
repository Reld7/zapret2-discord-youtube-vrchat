@echo off
chcp 65001 > nul
:: 65001 - UTF-8

cd /d "%~dp0"
call service.bat status_zapret
call service.bat check_updates
call service.bat load_game_filter
call service.bat load_user_lists
echo:

set "BIN=%~dp0bin\"
set "LISTS=%~dp0lists\"
set "WD=%~dp0windivert.filter\"
cd /d %BIN%

start "zapret2: %~n0" /min "%BIN%winws2.exe" ^
--lua-init=@"%BIN%zapret-lib.lua" ^
--lua-init=@"%BIN%zapret-antidpi.lua" ^
--lua-init=@"%BIN%zapret-auto.lua" ^
--blob=quic_google:"%BIN%quic_initial_www_google_com.bin" ^
--blob=discord_udp:"%BIN%ACTIVE_DISCORD_UDP.bin" ^
--blob=tls_google:"%BIN%tls_clienthello_www_google_com.bin" ^
--blob=tls_vk:"%BIN%tls_clienthello_api_vk_ru_no_kyber_ff.bin" ^
--blob=quic_yandex:"%BIN%quic_initial_quic_egress_yandex_net_no_kyber_ff.bin" ^
--blob=game_udp:"%BIN%ACTIVE_GAME_UDP.bin" ^
--wf-tcp-out=80,443,2053,2083,2087,2096,8443,%GameFilterTCP% ^
--wf-udp-out=443,19294-19344,50000-50100,%GameFilterUDP% ^
--wf-raw-part=@"%WD%windivert_part.vrchat.txt" ^

--name="domain quic" ^
--filter-udp=443 ^
  --hostlist="%LISTS%list-general.txt" ^
  --hostlist="%LISTS%list-general-user.txt" ^
  --hostlist-exclude="%LISTS%list-exclude.txt" ^
  --hostlist-exclude="%LISTS%list-exclude-user.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude-user.txt" ^
  --payload=quic_initial ^
  --lua-desync=fake:blob=quic_google:repeats=11 ^
--new ^

--name="discord voice" ^
--filter-udp=19294-19344,50000-50100 ^
  --filter-l7=discord,stun ^
  --payload=discord_ip_discovery,stun ^
  --lua-desync=fake:blob=discord_udp:repeats=6 ^
--new ^

--name="discord media" ^
--filter-tcp=2053,2083,2087,2096,8443 ^
  --hostlist-domains=discord.media ^
  --payload=tls_client_hello ^
  --lua-desync=fake:blob=tls_google:repeats=11:tcp_seq=2:tcp_ack=-66000:tcp_ts_up:tls_mod=rnd,dupsid:sni=www.google.com ^
  --lua-desync=multidisorder:pos=1,midsld ^
--new ^

--name="youtube" ^
--filter-tcp=443 ^
  --hostlist="%LISTS%list-google.txt" ^
  --payload=tls_client_hello ^
  --lua-desync=fake:blob=tls_google:repeats=11:tcp_seq=2:tcp_ack=-66000:tcp_ts_up:tls_mod=rnd,dupsid:sni=www.google.com:ip_id=zero ^
  --lua-desync=multidisorder:pos=1,midsld:ip_id=zero ^
--new ^

--name="domain tls" ^
--filter-tcp=80,443 ^
  --hostlist="%LISTS%list-general.txt" ^
  --hostlist="%LISTS%list-general-user.txt" ^
  --hostlist-exclude="%LISTS%list-exclude.txt" ^
  --hostlist-exclude="%LISTS%list-exclude-user.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude-user.txt" ^
  --payload=tls_client_hello,http_req ^
  --lua-desync=fake:blob=tls_google:repeats=11:tcp_seq=2:tcp_ack=-66000:tcp_ts_up:tls_mod=rnd,dupsid:sni=www.google.com:payload=tls_client_hello ^
  --lua-desync=fake:blob=tls_vk:repeats=11:tcp_seq=2:tcp_ack=-66000:tcp_ts_up:payload=http_req ^
  --lua-desync=multidisorder:pos=1,midsld ^
--new ^

--name="ip quic" ^
--filter-udp=443 ^
  --ipset="%LISTS%ipset-all.txt" ^
  --hostlist-exclude="%LISTS%list-exclude.txt" ^
  --hostlist-exclude="%LISTS%list-exclude-user.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude-user.txt" ^
  --payload=quic_initial ^
  --lua-desync=fake:blob=quic_google:repeats=11 ^
--new ^

--name="ip tls" ^
--filter-tcp=80,443,8443 ^
  --ipset="%LISTS%ipset-all.txt" ^
  --hostlist-exclude="%LISTS%list-exclude.txt" ^
  --hostlist-exclude="%LISTS%list-exclude-user.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude-user.txt" ^
  --payload=tls_client_hello,http_req ^
  --lua-desync=fake:blob=tls_google:repeats=11:tcp_seq=2:tcp_ack=-66000:tcp_ts_up:tls_mod=rnd,dupsid:sni=www.google.com:payload=tls_client_hello ^
  --lua-desync=fake:blob=tls_vk:repeats=11:tcp_seq=2:tcp_ack=-66000:tcp_ts_up:payload=http_req ^
  --lua-desync=multidisorder:pos=1,midsld ^
--new ^

--name="photonengine udp" ^
--filter-udp=5055,5056,27001,27002 ^
  --out-range=-n4 ^
  --payload=all ^
  --lua-desync=fake:blob=quic_yandex:repeats=12 ^
--new ^

--name="gamefiltertcp" ^
--filter-tcp=%GameFilterTCP% ^
  --ipset="%LISTS%ipset-all.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude-user.txt" ^
  --out-range=-n4 ^
  --payload=tls_client_hello,http_req,unknown ^
  --lua-desync=fake:blob=tls_google:repeats=11:tcp_seq=2:tcp_ack=-66000:tcp_ts_up:tls_mod=rnd,dupsid:sni=www.google.com:payload=tls_client_hello,unknown ^
  --lua-desync=fake:blob=tls_vk:repeats=11:tcp_seq=2:tcp_ack=-66000:tcp_ts_up:payload=http_req,unknown ^
  --lua-desync=multidisorder:pos=1,midsld ^
--new ^

--name="gamefilterudp" ^
--filter-udp=%GameFilterUDP% ^
  --ipset="%LISTS%ipset-all.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude.txt" ^
  --ipset-exclude="%LISTS%ipset-exclude-user.txt" ^
  --out-range=-n2 ^
  --payload=all ^
  --lua-desync=fake:blob=game_udp:repeats=10 ^
--new ^