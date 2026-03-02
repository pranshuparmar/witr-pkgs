# witr

**witr** exists to answer a single question:

> **Why is this running?**

When something is running on a system, whether it is a process, a service, or something bound to a port, there is always a cause. That cause is often indirect, non-obvious, or spread across multiple layers such as supervisors, containers, services, or shells.

Existing tools (`ps`, `top`, `lsof`, `ss`, `systemctl`, `docker ps`) expose state and metadata. They show _what_ is running, but leave the user to infer _why_ by manually correlating outputs across tools.

**witr** makes that causality explicit.

It explains **where a running thing came from**, **how it was started**, and **what chain of systems is responsible for it existing right now**, in a single, human-readable output or an **interactive TUI dashboard**.

---

## Installation

```
npm install -g @pranshuparmar/witr
```

## Project Link

https://github.com/pranshuparmar/witr
