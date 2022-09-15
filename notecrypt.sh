#!/bin/bash
case $1 in

  init)
    mkdir ~/.notecrypt 2>/dev/null
    ;;

  insert)
    if [ -z "$2" ]; then
    echo "Введите имя новой заметки. notecrypt insert [name]"
    exit
    fi
    if ! ls ~/.notecrypt/ 1>/dev/null 2>/dev/null; then
    echo "Криптохранилище не инициализировано. Для инициализации введите notecrypt init"
    exit
    fi
    if ~/.notecrypt/$2 1>/dev/null 2>/dev/null; then
    echo "Заметка $2 существует. Для её изменения введите notecrypt modyfy $2"
    exit
    fi
    nano ~/.notecrypt/$2.tmp
    gpg -c -o ~/.notecrypt/$2  ~/.notecrypt/$2.tmp
    srm ~/.notecrypt/$2.tmp
    ;;

  list)
    if ! ls ~/.notecrypt/ 1>/dev/null 2>/dev/null; then
    echo "Криптохранилище не инициализировано. Для инициализации введите notecrypt init"
    exit
    fi
    ls -la ~/.notecrypt/ | awk '{print $9}' | tail -n +4
    ;;

  modify)
    if [ -z "$2" ]; then
    echo "Введите имя заметки. notecrypt modify [name]"
    exit
    fi
    if ! ls ~/.notecrypt/ 1>/dev/null 2>/dev/null; then
    echo "Криптохранилище не инициализировано. Для инициализации введите notecrypt init"
    exit
    fi
    if ! gpg -d  -o ~/.notecrypt/$2.tmp  ~/.notecrypt/$2 2>/dev/null; then
    echo "Файл не найден. Для просмотра списка файлов введите: notecrypt list"
    exit
    fi
    nano ~/.notecrypt/$2.tmp
    srm ~/.notecrypt/$2
    gpg -c -o ~/.notecrypt/$2 ~/.notecrypt/$2.tmp
    srm ~/.notecrypt/$2.tmp
    ;;

  readnote)
    if ! ls ~/.notecrypt/ 1>/dev/null 2>/dev/null; then
    echo "Криптохранилище не инициализировано. Для инициализации введите notecrypt init"
    exit
    fi
    if ! gpg -d ~/.notecrypt/$2 2>/dev/null; then
    echo "Файл не найден. Для просмотра списка файлов введите: notecrypt list"
    fi
    ;;

  del)
    echo "Вы уверены, что хотите удалить $2 ?"
    read a
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        srm ~/.notecrypt/$2
    else
        echo "Файл не удалён."
    fi
    ;;

  *)
    echo "notecrypt init            - Инициализировать криптохранилище."
    echo "notecrypt insert [name]   - Добавить криптозаметку."
    echo "notecrypt list  [name]    - Посмотреть список криптозаметок."
    echo "notecrypt modify [name]   - изменить криптозаметку."
    echo "notecrypt readnote [name] - расшифровать и прочитать криптозаметку."
    echo "notecrypt del [name]      - Удалить криптозаметку."
    echo "Важный момент notecrypt использует nano для создания и редактирования заметок. После необходимо нажать CTRL+O Enter CTRL+X. Ни в коем случае не изменяйте имя временного файла."
    ;;
esac
