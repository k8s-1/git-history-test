# git-history-test
Test git history operations with --single-branch flag.

1. Clone the default branch with --single-branch:
```
git clone --single-branch git@github.com:k8s-1/git-history-test.git git-history-test
```

2. Checkout a commit in `staging` branch:
```
git checkout f11a16a183fbf25742b442b22a1d2c1436fa2501
fatal: unable to read tree (f11a16a183fbf25742b442b22a1d2c1436fa2501)
```
 
