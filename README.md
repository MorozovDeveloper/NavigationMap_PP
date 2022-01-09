# Описание pet-проекта:

Простой навигатор, показывающий текущее нахождение пользователя и маршрут до заданного адреса с возможностью сохранения любимого маршрута в таблицу. Также, свайпом по карте, textField моментально отображает адрес находящийся по центру экрана.

```
Применение:
MVVM
MapKit
CoreData
______________________________________

Баги(в процессе исправления):
- При построении нового маршрута, старая линия удаляется а метка с адресом нет.
Возможное решение: сделать аналог метода resetMapView только для метки.
- Не совсем верно сделано по архитектуре MVVM.
Возможное решение: вынести view controllers не через extension, а через новый class.

```


<img src="https://user-images.githubusercontent.com/76910221/148353922-9394c925-336d-4307-9f28-9c56838f03b0.png" width="200" height="400" />
<img src="https://user-images.githubusercontent.com/76910221/148353975-527589ff-a92c-4e4c-8a46-1a3f7d83d2a1.png" width="200" height="400" />
<img src="https://user-images.githubusercontent.com/76910221/148354049-4c23284e-a615-4dda-ac8a-d9cc64e6bbb3.png" width="200" height="400" />


