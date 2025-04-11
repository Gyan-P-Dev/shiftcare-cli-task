# ShiftCare CLI

A Ruby-based command-line tool for interacting with ShiftCare client data.

This CLI allows users to:

- Search for clients based on specific fields
- Detect duplicate email addresses in the dataset

## 📦 Requirements

- Ruby 3.3.6
- Bundler

## 🔧 Setup Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/your-username/shiftcare_cli.git
   cd shiftcare_cli
   ```

2. **Install dependencies**:

   ```bash
   bundle install
   ```

3. **Run the CLI**:

   ```bash
   ruby bin/shiftcare_cli
   ```

## ▶️ Usage Instructions

You can run the CLI with various commands:

### 1. Show total clients:

```bash
ruby bin/shiftcare_cli
```

### 2. Search clients by field (e.g. `full_name`, `email`):

```bash
ruby bin/shiftcare_cli search full_name john
```

### 3. Detect duplicate emails:

```bash
ruby bin/shiftcare_cli duplicate_email
```

### 4. View help:

```bash
ruby bin/shiftcare_cli help
```

---

## 📌 Assumptions and Decisions

- **Data Source**: Client data is fetched from the ShiftCare-hosted JSON file:  
  `https://appassets02.shiftcare.com/manual/clients.json`
- **Client Structure**: Assumed to have keys like `id`, `full_name`, `email`, etc.
- **Email Duplication**: Clients with the same email are considered duplicates regardless of their full name.
- **No persistent storage**: Data is fetched fresh each time from the remote JSON file.

---

## ⚠️ Known Limitations

- **No offline support**: If the client data URL is unreachable, the app won’t function.
- **Field Sensitivity**: Searches depend on method names (e.g., `full_name`), and mistyped fields may raise errors.
- **Limited Commands**: Currently supports only `search` and `duplicate_email` commands.

---

## 🚀 Future Improvements

- Add fuzzy search and better error handling for unknown fields.
- Support for more advanced queries (e.g., `AND`, `OR`, regex).
- Add caching/local storage support for offline mode.
- Support exporting results (e.g., to CSV or JSON).
- Better CLI experience using libraries like `Thor` or `TTY::Prompt`.

---

## ✅ Running Tests

Run the test suite using:

```bash
bundle exec rspec
```
