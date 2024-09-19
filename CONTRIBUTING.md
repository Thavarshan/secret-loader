# Contributing to Secrets Loader

Thank you for your interest in contributing to **Secrets Loader**! We welcome contributions from the community, and we’re excited to collaborate with you.

## How to Contribute

### Reporting Issues

If you find any bugs, have feature requests, or experience problems, please [open an issue](https://github.com/Thavarshan/envsecrets/issues) and provide as much detail as possible.

### Suggesting Enhancements

If you have ideas to improve the project, feel free to submit a feature request via an issue or, even better, submit a pull request with your suggestions.

### Pull Requests

We welcome pull requests from the community. If you would like to submit a pull request, please follow these steps:

1. **Fork the repository** and clone your fork locally.

   ```bash
   git clone https://github.com/YOUR_USERNAME/envsecrets.git
   cd envsecrets
   ```

2. **Create a new branch** for your feature or bugfix.

   ```bash
   git checkout -b your-branch-name
   ```

3. **Make your changes** and commit them with clear and descriptive messages.

   ```bash
   git add .
   git commit -m "Add feature or fix description"
   ```

4. **Push your changes** to your fork.

   ```bash
   git push origin your-branch-name
   ```

5. **Submit a pull request** on the original repository, providing a clear description of the changes and the problem or feature they address.

### Writing Tests

Please ensure that any new features or bug fixes are accompanied by relevant unit tests. We use [BATS](https://github.com/bats-core/bats-core) for testing. You can run the test suite using:

```bash
bats test_secrets.bats
```

Make sure all tests pass before submitting a pull request.

### Code Style

- Follow best practices for writing clean, readable Bash scripts.
- Keep your commits focused. Each commit should represent a single change.
- Avoid large "monolithic" commits with multiple unrelated changes.

## Code of Conduct

Please adhere to our [Code of Conduct](CODE_OF_CONDUCT.md) when participating in the project. We expect everyone in the community to be respectful and constructive when contributing.
