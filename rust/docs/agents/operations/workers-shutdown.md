# Workers and Shutdown

Read for spawned background tasks, queue consumers, scheduled jobs, or servers.

- Track task errors and pass shutdown/cancellation signals to owned child tasks.
- Stop intake before draining or safely canceling in-flight work.
- Bound queues and worker concurrency under downstream outages.
- Define retry limits and durable failure handling.
- Avoid duplicate scheduled execution across replicas unless intended.
- Compare container termination grace periods to expected shutdown duration.
- Test interrupted work, startup, and clean shutdown where feasible.
