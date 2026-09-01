function t --description "Run tests (optionally filtered)"
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

    # Detect test runner from package.json
    set -l test_runner ""
    if grep -q '"vitest"' package.json; or test -f vitest.config.ts; or test -f vitest.config.js
        set test_runner vitest
    else if grep -q '"jest"' package.json; or test -f jest.config.ts; or test -f jest.config.js
        set test_runner jest
    end

    if test -z "$test_runner"
        # Fallback to npm test
        echo "Running: $pkg_manager test $filter"
        if test -n "$filter"
            $pkg_manager test -- $filter
        else
            $pkg_manager test
        end
        return
    end

    echo "Running: $pkg_manager exec $test_runner $filter"
    if test -n "$filter"
        $pkg_manager exec $test_runner run $filter
    else
        $pkg_manager exec $test_runner run
    end
end
