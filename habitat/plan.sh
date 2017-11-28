pkg_name=rocketry
pkg_origin=fnichol
pkg_version=0.0.1
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('Apache-2.0')
# The result is a portable, static binary in a zero-dependency package.
pkg_deps=()
pkg_build_deps=(core/musl core/coreutils core/rust-nightly core/gcc)
pkg_exports=(
  [port]=http.port
)
pkg_exposes=(port)
pkg_bin_dirs=(bin)

_bin="$pkg_name"
pkg_svc_run="$_bin {{cfg.http.port}}"

do_prepare() {
  # Can be either `--release` or `--debug` to determine cargo build strategy
  build_type="--release"
  build_line "Building artifacts with \`${build_type#--}' mode"

  export rustc_target="x86_64-unknown-linux-musl"
  build_line "Setting rustc_target=$rustc_target"

  export CARGO_TARGET_DIR="$HAB_CACHE_SRC_PATH/$pkg_dirname"
  build_line "Setting CARGO_TARGET_DIR=$CARGO_TARGET_DIR"

  # Used to find libgcc_s.so.1 when compiling `build.rs` in dependencies. Since
  # this used only at build time, we will use the version found in the gcc
  # package proper--it won't find its way into the final binaries.
  export LD_LIBRARY_PATH=$(pkg_path_for gcc)/lib
  build_line "Setting LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
}

do_build() {
  cargo build "${build_type#--debug}" --target="$rustc_target" --verbose
}

do_install() {
  install -v -D "$CARGO_TARGET_DIR/$rustc_target/${build_type#--}/$_bin" \
    "$pkg_prefix/bin/$_bin"
}

do_strip() {
  if [[ "$build_type" != "--debug" ]]; then
    do_default_strip
  fi
}

do_build_service() {
  do_default_build_service
  # Quick hack to place the `run` hook under `hooks/` so that the Supervisor
  # will pass it through templating
  mkdir -pv "$pkg_prefix/hooks"
  mv -v "$pkg_prefix/run" "$pkg_prefix/hooks/run"
}
