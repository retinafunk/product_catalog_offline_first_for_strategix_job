# product_catalog_offline_first_for_strategix_job

    An offline first product catalog app - implementation tech skills evaluation task for Strategix job

## DEV PROCESS DOCS :

## possible Strategy for an Offline-First flutter app

# Init Flow

Lifecycle Events : onAppStart

*IF device is online* / connected to internet :
THEN

1. App fetches initial first time the (mock) products as structured JSON from (mock) REST API
2. Save products locally with HIVE or SQLLite
3. Display products (as a custom list or grid widget)
4. Save init. time stamp for cache in local storage or Hive

*ELSE IF
we are offline* / no internet connection:

1. TRY to Read (mock) products list from local storage / hive /  database
2. Show cached products list / grid  immediately
3. Display offline (toast widget or small offline state banner

## Web offline notes

- App shell offline requires a release build so the service worker is registered.
- Product images are cached locally in Hive (IndexedDB on web) after they load.
- Open the app once online so images are stored, then reload while offline.
