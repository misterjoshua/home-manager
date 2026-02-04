set -ueo pipefail

OUT_DIR=${OUT_DIR:-./_out}
ED25519_PRIVATE_KEY_PATH=${ED25519_PRIVATE_KEY_PATH:-${OUT_DIR}/id_ed25519}
ED25519_PUBLIC_KEY_PATH=${ED25519_PUBLIC_KEY_PATH:-${OUT_DIR}/id_ed25519.pub}
AGE_PRIVATE_KEY_PATH=${AGE_PRIVATE_KEY_PATH:-${OUT_DIR}/age.key}
AGE_PUBLIC_KEY_PATH=${AGE_PUBLIC_KEY_PATH:-${OUT_DIR}/age.key.pub}

IDENTITY_NAME=${IDENTITY_NAME:-"$USER@$HOSTNAME"}

generate_id_ed25519() {
    mkdir -p $(dirname $ED25519_PRIVATE_KEY_PATH)
    echo "Ensuring ED25519 private key exists at $ED25519_PRIVATE_KEY_PATH"
    if [ ! -f $ED25519_PRIVATE_KEY_PATH ]; then
        ssh-keygen -t ed25519 -C "$IDENTITY_NAME" -f $ED25519_PRIVATE_KEY_PATH -N ""
    fi

    echo "Ensuring ED25519 private key is chmod 600"
    chmod 600 $ED25519_PRIVATE_KEY_PATH

    mkdir -p $(dirname $ED25519_PUBLIC_KEY_PATH)
    echo "Ensuring ED25519 public key exists at $ED25519_PUBLIC_KEY_PATH"
    if [ ! -f $ED25519_PUBLIC_KEY_PATH ]; then
        ssh-keygen -y -f $ED25519_PRIVATE_KEY_PATH > $ED25519_PUBLIC_KEY_PATH
    fi

    echo "Ensuring ED25519 public key is chmod 644"
    chmod 644 $ED25519_PUBLIC_KEY_PATH
}

generate_age() {
    mkdir -p $(dirname $AGE_PRIVATE_KEY_PATH)
    echo "Ensuring Age private key exists at $AGE_PRIVATE_KEY_PATH"
    if [ ! -f $AGE_PRIVATE_KEY_PATH ]; then
        age-keygen -o $AGE_PRIVATE_KEY_PATH
    fi

    echo "Ensuring Age private key is chmod 600"
    chmod 600 $AGE_PRIVATE_KEY_PATH

    mkdir -p $(dirname $AGE_PUBLIC_KEY_PATH)
    echo "Ensuring Age public key exists at $AGE_PUBLIC_KEY_PATH"
    if [ ! -f $AGE_PUBLIC_KEY_PATH ]; then
        age-keygen -y -o $AGE_PUBLIC_KEY_PATH $AGE_PRIVATE_KEY_PATH
    fi

    echo "Ensuring Age public key is chmod 644"
    chmod 644 $AGE_PUBLIC_KEY_PATH
}

for arg in "$@"; do
    case $arg in
        id_ed25519)
            generate_id_ed25519
            ;;
        age)
            generate_age
            ;;
    esac
done