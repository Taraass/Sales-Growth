# Sales-Growth

Цей проект містить компоненти для системи аналізу та прогнозування маркетингової діяльності компанії. Цей опис дасть можливість розгорнути код за допомогою Salesforce CLI (SFDX).

## Вимоги

Для початку потрібно встановити Salesforce CLI, який дасть змогу виконувати команди SFPX.
- [Salesforce CLI (SFDX)](https://developer.salesforce.com/tools/sfdxcli) – для виконання команд SFDX.
- Обліковий запис Salesforce (Developer Edition або Scratch Org).

## Клонування репозиторію
Необхідно клонувати репозиторій на локальний комп'ютер для розгортання системи


```git clone https://github.com/your-username/your-repository-name.git](https://github.com/Taraass/Sales-Growth.git```
Далі необхідно авторизуватись у середовище:

```sfdx auth:web:login -a your-org-alias```

Наступним кроком є створення проекту за допомогою команди sfpx
```sfdx force:org:create -f config/project-scratch-def.json -a your-scratch-org-alias -s```

Далі необхідно виконати розгортання на середовищі за допомогою команди
```sfdx force:source:deploy -u your-sandbox-alias -x manifest/package.xml```


Для доступу до середовища для користувача, можна використовувати посилання 
```https://mindful-goat-2n0drh-dev-ed.trailblaze.my.salesforce.com/```
