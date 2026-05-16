# Discount Bank — iOS Interview App

A SwiftUI banking demo app built for the Discount Bank interview. It showcases a custom design system, mock authentication, account overview, and transaction management with local persistence for edits.

## Requirements

- Xcode 16+ (Swift 5.9+)
- iOS 17.0+
- macOS for building and running the simulator

## Getting Started

1. Clone the repository.
2. Open `DiscountBank-interview.xcodeproj` in Xcode.
3. Select the **DiscountBank-interview** scheme and an iOS Simulator.
4. Build and run (**⌘R**).

No API keys or backend setup are required — demo data is provided in-app.

---

## Main Features

### Sign in (demo)

- Username and password fields with validation.
- **Demo Account** toggle (`DSToggle`) — when enabled, sign-in loads mock bank data via `MockBankRepository`.
- **Forgot Password?** shows a playful alert (“bummer…”).

### Home — accounts & balance

- **Account picker** — filter by a single account or **All accounts**.
- Balance title adapts (“Total balance” vs “Balance”).

### Recent activity

- Scrollable transaction list with title, date, account, category icon, and signed amount (green credits / red debits).
- **Period filter** (1 month, 3 months, 6 months, 1 year, Max) via a filter icon menu.
- Tap a row to open transaction details.

### Transaction detail

- Sheet presentation with medium/large detents.
- Details: sender, receiver, account, date, transaction ID.
- **Edit mode** (pencil / checkmark) — update title, category, sender, receiver, and date.
- Edits are saved to **`BankStore`** and persisted locally with **SwiftData** (survive app restarts in demo mode).

### Design system

Local Swift package at `Packages/DesignSystem/`:

| Component   | Purpose                                               |
|-------------|-------------------------------------------------------|
| `DSButton`  | Primary, secondary, and ghost actions                 |
| `DSCard`    | Elevated content containers                           |
| `DSListRow` | Transaction and list rows                             |
| `DSAmountText`| Formatted currency (monochrome & semantic coloring) |
| `DSToggle`  | Custom switch with accent + gradient                  |
| `DSSectionHeader` | Section labels                                  |  
| Tokens      | Colors, typography (Roboto), spacing, radius          |

Light and dark mode are supported via asset catalogs and semantic colors.

---

## Architecture

```
App/                    → App entry, session routing (login vs home)
Domain/                 → Models, BankStore, BankRepository, mock data
Features/
  Authentication/       → Login (MVVM)
  Home/                 → ContentView (balance + header)
  Transactions/         → List, detail, detail ViewModel (MVVM)
Persistence/            → SwiftData transaction overrides
Utilities/              → Shared helpers (keyboard observer, test flags)
Packages/DesignSystem/  → Reusable UI components & tokens
```

- **`BankStore`** (`@Observable`) — central app state: user, accounts, transactions, filters, selection.
- **`BankRepository`** — abstraction for loading session data; **`MockBankRepository`** implements demo sign-in.
- **MVVM** on login and transaction detail; home and list read from `BankStore` via `@Environment`.
- **SwiftData** stores per-transaction edit overrides merged when demo data loads.

---

## Tests

Unit tests live in `DiscountBank-interviewTests/`:

- Domain: `MockBankRepository`, `Transaction`, `TransactionPeriodFilter`
- Features: `LoginViewModel`

Run tests in Xcode with **⌘U** or the Test navigator.

---

## Project Notes

- This is a **demo / interview** project — there is no real authentication or live banking API.
- Figma reference tokens are kept under `DiscountBank-interview/Resources/Reference/` for design alignment only.
- Asset catalog includes app icon and `discountBankLogo` for branding.

---

## Author

Aviram Netanel — Discount Bank interview submission.
