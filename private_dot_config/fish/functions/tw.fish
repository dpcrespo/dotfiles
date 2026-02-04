function tw --description "Run tests in watch mode"
    set -l filter $argv[1]

    # Check for package.json
    if not test -f package.json
        echo "No package.json found in current directory"
        return 1
    end

    # Detect package manager
    set -l pkg_manager npm
    if test -f pnpm-lock.yaml
        set pkg_manager pnpm
    else if test -f yarn.lock
        set pkg_manager yarn
    else if test -f bun.lockb
        set pkg_manager bun
    end

    # Detect test runner
    set -l test_runner ""
    if grep -q '"vitest"' package.json; or test -f vitest.config.ts; or test -f vitest.config.js
        set test_runner vitest
    else if grep -q '"jest"' package.json; or test -f jest.config.ts; or test -f jest.config.js
        set test_runner jest
    end

    if test -z "$test_runner"
        echo "No test runner detected (vitest/jest)"
        return 1
    end

    echo "Running: $pkg_manager exec $test_runner --watch $filter"
    if test -n "$filter"
        $pkg_manager exec $test_runner --watch $filter
    else
        $pkg_manager exec $test_runner --watch
    end
end
