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

## Architecture & Design Decisions

### Architecture
This project follows a simple clean architecture split:
- **Presentation**: UI and state bindings (`lib/presentation/...`)
- **Domain**: Entities and repository contracts (`lib/domain/...`)
- **Data**: Remote + local implementations (`lib/data/...`)

The `ProductRepository` orchestrates offline-first behavior, keeping UI code simple and testable.

### Offline-First Strategy
- **Online**: fetch from API → cache locally in Hive → display fresh data.
- **Offline / failure**: read from Hive → display cached data with an offline indicator.

Implementation: `lib/data/repositories/product_repository_impl.dart`,  
local cache: `lib/data/datasources/local_product_datasource.dart`,  
favorites: `lib/data/datasources/favorites_local_datasource.dart`.

### State Management (Riverpod)
**Why Riverpod**:
- Clear separation between UI and business logic.
- Easy dependency injection for repositories and data sources.
- Simple testing via provider overrides.

Providers live in `lib/presentation/providers/`.

### Local Persistence (Hive)
**Why Hive**:
- Fast local storage with minimal boilerplate.
- Works on mobile and web (IndexedDB on web).
- JSON storage avoids code generation for this small app.

### Trade-offs / Limitations
- Hive JSON storage trades strong typing for speed and simplicity.
- Web offline requires a release build for the service worker.
- Images are cached after first load; prefetching could improve cold offline UX.

### Testing Notes
The repository and providers are designed to be unit-tested via Riverpod overrides.