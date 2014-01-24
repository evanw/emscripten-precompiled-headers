SOURCES = \
	src/main.cpp \
	src/a_value.cpp \
	src/a_reader.cpp \
	src/a_writer.cpp \
	src/b_value.cpp \
	src/b_reader.cpp \
	src/b_writer.cpp \
	src/c_value.cpp \
	src/c_reader.cpp \
	src/c_writer.cpp \
	src/d_value.cpp \
	src/d_reader.cpp \
	src/d_writer.cpp \
	src/e_value.cpp \
	src/e_reader.cpp \
	src/e_writer.cpp \
	json/json_writer.cpp \
	json/json_reader.cpp \
	json/json_value.cpp

CPP_FLAGS = \
	-I. \
	-Ijson \
	-Wall \
	-Wextra

JS_FLAGS = \
	-v \
	-o compiled.js

SDK = $(shell echo ~/.emsdk_portable)
EMSCRIPTEN = LLVM=$(SDK)/clang/3.2_64bit/bin PATH=`$(SDK)/emsdk active_path emscripten-1.7.8`:$(PATH) python $(SDK)/emscripten/1.7.8/emcc

default:
	@echo 'either "make slow" or "make fast"'

sdk:
	test -d $(SDK) || (curl -O https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz && \
		tar xzf emsdk-portable.tar.gz && rm -f emsdk-portable.tar.gz && mv emsdk_portable $(SDK))
	test -d $(SDK)/emscripten/1.7.8 || ($(SDK)/emsdk install emscripten-1.7.8 && $(SDK)/emsdk install clang-3.2-64bit)

slow: sdk
	$(EMSCRIPTEN) $(SOURCES) $(CPP_FLAGS) $(JS_FLAGS)

fast: sdk
	# Build the precompiled header (these arguments were mostly copied and pasted from emcc -v on OS X)
	$(SDK)/clang/3.2_64bit/bin/clang++ \
		-DEMSCRIPTEN \
		-D__EMSCRIPTEN__ \
		-fno-math-errno \
		-target le32-unknown-nacl \
		-U__native_client__ \
		-U__pnacl__ \
		-U__ELF__ \
		-nostdinc \
		-Xclang -nobuiltininc \
		-Xclang -nostdsysteminc \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/local/include \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include/compat \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include/libcxx \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include/emscripten \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include/bsd \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include/libc \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include/gfx \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include/net \
		-Xclang -isystem$(SDK)/emscripten/1.7.8/system/include/SDL \
		-U__i386__ \
		-U__i386 \
		-Ui386 \
		-U__STRICT_ANSI__ \
		-D__IEEE_LITTLE_ENDIAN \
		-U__SSE__ \
		-U__SSE_MATH__ \
		-U__SSE2__ \
		-U__SSE2_MATH__ \
		-U__MMX__ \
		-U__APPLE__ \
		-U__linux__ \
		-std=c++03 \
		-emit-llvm \
		-v \
		-xc++-header \
		$(CPP_FLAGS) \
		-c src/common.h
	EMMAKEN_CFLAGS='-include src/common.h' $(EMSCRIPTEN) $(SOURCES) $(CPP_FLAGS) $(JS_FLAGS)
