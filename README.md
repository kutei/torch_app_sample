## How-to

1. how to start poetry system

    ```console
    docker compose run --rm torch_app poetry init
    ```

1. how to add torch dependencies (you could change part of `torch_cu121`)

    ```console
    docker compose run --rm -it torch_app bash

    (inside docker)& poetry source add torch_cu121 --priority=explicit https://download.pytorch.org/whl/cu121
    (inside docker)& poetry add torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 --source torch_cu121
    ```


## 参考サイト

1. https://scrapbox.io/miyamonz/poetry%E7%AD%89%E3%81%A7dockerfile%E4%BD%9C%E3%82%8B
1. https://github.com/python-poetry/install.python-poetry.org
1. https://zenn.dev/rihito/articles/7b48821e4a3f74
