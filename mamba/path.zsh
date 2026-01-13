# -----------------------------
# Miniforge / Mamba 2.0 Setup
# -----------------------------

# 1. Define the Root Prefix (Required for Mamba 2.0+)
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
export CONDA_PREFIX_PATH="$HOME/miniforge3"

# 2. Add Miniforge binaris to PATH
# export PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"

# 3. Initialize Shell Integration
if [ -f "$MAMBA_ROOT_PREFIX/etc/profile.d/conda.sh" ]; then
    source "$MAMBA_ROOT_PREFIX/etc/profile.d/conda.sh"
    source "$MAMBA_ROOT_PREFIX/etc/profile.d/mamba.sh"
fi

# 4. Disable auto-activation of base environment
export CONDA_AUTO_ACTIVATE_BASE=false
