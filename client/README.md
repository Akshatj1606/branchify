## Prerequisites

Before you begin, ensure you have the following installed on your local machine:
- Node.js (v18 or higher recommended)
- [Yarn](https://yarnpkg.com/) package manager (v1.22+)

## Getting Started

Follow these steps to get the development server running locally after cloning the repository.

### 1. Install Dependencies

Navigate into the `client` directory and install the necessary dependencies using yarn:

```bash
yarn install
```

### 2. Environment Variables

If there is a `.env.example` file, copy it and rename it to `.env`:

```bash
cp .env.example .env
```
*(Note: Be sure to populate your `.env` file with the necessary `VITE_*` variables if required by your configuration, e.g., `VITE_API_URL`.)*

### 3. Start the Development Server

Start the Vite development server:

```bash
yarn dev
```

The application will now be running on [http://localhost:3000](http://localhost:3000)

## Technology Stack

- **Framework**: React 19 + Vite
- **Styling**: Tailwind CSS
- **Components**: Radix UI / shadcn/ui
- **Routing**: React Router DOM (v7)

---
