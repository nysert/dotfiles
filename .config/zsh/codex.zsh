# -----------------------------------------------------------------------------
# LiteLLM
# -----------------------------------------------------------------------------

LITELLM_PORT=4040
LITELLM_PID_FILE="$HOME/.config/litellm/litellm.pid"
LITELLM_LOG_FILE="$HOME/.config/litellm/litellm.log"

litellm-load-env() {
  set -a
  source "$HOME/.config/litellm/env"
  set +a
}

litellm-healthcheck() {
  if ! curl \
    --silent \
    --fail \
    --max-time 2 \
    "http://127.0.0.1:${LITELLM_PORT}/health/liveliness" \
    > /dev/null
  then
    echo "LiteLLM is not running."
    return 1
  fi
}

# Foreground
litellm-start() {
  litellm-load-env

  litellm \
    --config "$HOME/.config/litellm/config.yaml" \
    --host 127.0.0.1 \
    --port "$LITELLM_PORT" \
    "$@"
}

# Detached / background
litellm-startd() {
  if litellm-healthcheck > /dev/null 2>&1; then
    echo "LiteLLM is already running."
    return 0
  fi

  litellm-load-env

  nohup litellm \
    --config "$HOME/.config/litellm/config.yaml" \
    --host 127.0.0.1 \
    --port "$LITELLM_PORT" \
    "$@" \
    > "$LITELLM_LOG_FILE" 2>&1 &

  local pid=$!
  echo "$pid" > "$LITELLM_PID_FILE"

  for _ in {1..20}; do
    if litellm-healthcheck > /dev/null 2>&1; then
      echo "LiteLLM started in background."
      echo "PID: $pid"
      echo "Port: $LITELLM_PORT"
      echo "Log: $LITELLM_LOG_FILE"
      return 0
    fi

    sleep 0.5
  done

  echo "LiteLLM process started, but health check timed out."
  echo "PID: $pid"
  echo "Port: $LITELLM_PORT"
  echo "Check: $LITELLM_LOG_FILE"
  return 1
}

litellm-kill() {
  if [[ ! -f "$LITELLM_PID_FILE" ]]; then
    echo "LiteLLM PID file not found."
    return 1
  fi

  local pid
  pid="$(cat "$LITELLM_PID_FILE")"

  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid"
    echo "LiteLLM stopped (PID $pid)."
  else
    echo "LiteLLM process $pid is not running."
  fi

  rm -f "$LITELLM_PID_FILE"
}

litellm-restart() {
  litellm-kill 2>/dev/null
  sleep 1
  litellm-startd "$@"
}

litellm-status() {
  if litellm-healthcheck > /dev/null 2>&1; then
    echo "LiteLLM is running."
    echo "Port: $LITELLM_PORT"

    if [[ -f "$LITELLM_PID_FILE" ]]; then
      echo "PID: $(cat "$LITELLM_PID_FILE")"
    fi
  else
    echo "LiteLLM is not running."
    return 1
  fi
}

# -----------------------------------------------------------------------------
# Codex / OpenAI
# -----------------------------------------------------------------------------

codex-terra-medium() {
  codex --profile terra-medium "$@"
}

codex-sol-high() {
  codex --profile sol-high "$@"
}

codex-sol-xhigh() {
  codex --profile sol-xhigh "$@"
}

# -----------------------------------------------------------------------------
# Codex / Gemini
# -----------------------------------------------------------------------------

codex-gemini-medium() {
  litellm-healthcheck || return 1
  codex --profile gemini-medium "$@"
}

codex-gemini-high() {
  litellm-healthcheck || return 1
  codex --profile gemini-high "$@"
}


# -----------------------------------------------------------------------------
# DeepSeek
# -----------------------------------------------------------------------------

DEEPSEEK_ENV_FILE="$HOME/.config/deepseek/env"

deepseek-load-env() {
  if [[ ! -f "$DEEPSEEK_ENV_FILE" ]]; then
    echo "DeepSeek env file not found:"
    echo "$DEEPSEEK_ENV_FILE"
    return 1
  fi

  set -a
  source "$DEEPSEEK_ENV_FILE"
  set +a
}

codex-deepseek-low() {
  deepseek-load-env || return 1
  codex --profile deepseek-low "$@"
}

codex-deepseek-high() {
  deepseek-load-env || return 1
  codex --profile deepseek-high "$@"
}
