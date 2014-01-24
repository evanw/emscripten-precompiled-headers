# Precompiled headers for emscripten

This is a test case showing off precompiled headers working with emscripten. It just compiles JsonCpp a few times to simulate a real C++ code base. To build without precompiled headers, run:

    make slow

To build with precompiled headers, run:

    make fast

On my machine, a slow build takes 28 seconds and a fast build takes 17 seconds.
