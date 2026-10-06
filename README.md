# zapret2-discord-youtube-vrchat
Сборка на основе [flowseal/zapret-discord-youtube](https://github.com/flowseal/zapret-discord-youtube)
Оригинальный проект: [bol-van/zapret2](https://github.com/bol-van/zapret2)

>[!IMPORTANT]
>Все исполняемые и системные файлы в папке [bin](https://github.com/Reld7/zapret2-discord-youtube-vrchat/tree/main/bin) взяты из [zapret2/releases/v1.0.5.2](https://github.com/bol-van/zapret2/releases/tag/v1.0.5.2)
>Вы можете это проверить с помощью хэшей
>```
>certutil -hashfile "путькфайлу" SHA256
>```

## Использование
Процесс запуска идентичен оригинальному руководству от [flowseal/zapret-discord-youtube](https://github.com/flowseal/zapret-discord-youtube#%EF%B8%8F%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)

## Изменения
- Все стратегии адаптированы под синтаксис zapret 2
- В `list-general` добавлены домены vrchat
- Добавлен фильтр windivert для photon engine
- Часть фейков заменена на сгенерированные из firefox
- UDP порты 5055, 5056, 27001 и 27002 исключены из игрового фильтра
- Во все .bat файлы добавлена стратегия:
```
--filter-udp=5055,5056,27001,27002 ^
--payload=all ^
--out-range=-n4 ^
--lua-desync=fake:blob=quic_yandex:repeats=12 
```
