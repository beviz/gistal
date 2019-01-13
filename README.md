**Gistal** is a Multiple Gist files loader

### Usage

Install:

```bash
gem install gistal
```

Build a config file gistal.yml in your project or somewhere:

```yaml
gists:
  - name: Gist 1
    id: 7b21277a82ffac77d18b4bc8af5434a7
    dest: folder1
    files:
      - source: hello.sh
        chmod: +x
      - source: hello.md
        dest: folder2
        name: hi.md
  - name: Git flow
    id: 5903617
    dest: git-flow
    files:
      - source: README.md
      - source: "Git Flow.md"
```

Load:

```bash
gistal gistal.yml
```

### TODO

- [*] load files
- [ ] Tests
- [ ] version control with gistal.lock
