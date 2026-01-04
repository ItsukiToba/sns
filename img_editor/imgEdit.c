#include <stdio.h>
#include <stdlib.h>
#include <jpeglib.h>
#include <stdint.h>
#include <string.h>
#include <emscripten.h>

static uint8_t* output_buf = NULL;
static unsigned long output_size = 0;

EMSCRIPTEN_KEEPALIVE
uint8_t* get_result_ptr() {
    return output_buf;
}

EMSCRIPTEN_KEEPALIVE
int get_result_size() {
    return output_size;
}

// JPEG画像をRGBで読み込む
uint8_t* load_jpeg_from_memory(uint8_t* input_buf, int input_size, int* width, int* height) {
    struct jpeg_decompress_struct cinfo;
    struct jpeg_error_mgr jerr;

    cinfo.err = jpeg_std_error(&jerr);
    jpeg_create_decompress(&cinfo);
    jpeg_mem_src(&cinfo, input_buf, input_size);  // メモリから読み込む
    jpeg_read_header(&cinfo, TRUE);
    jpeg_start_decompress(&cinfo);
    
    *width = cinfo.output_width;
    *height = cinfo.output_height;
    
    int row_stride = *width * cinfo.output_components;
    uint8_t* buffer = (uint8_t*)malloc(*height * row_stride);
    JSAMPARRAY row_pointer = (*cinfo.mem->alloc_sarray)((j_common_ptr)&cinfo, JPOOL_IMAGE, row_stride, 1);
    
    for (int y = 0; y < *height; y++) {
        JDIMENSION lines = jpeg_read_scanlines(&cinfo, row_pointer, 1);
        memcpy(&buffer[y * row_stride], row_pointer[0], row_stride);
    }

    jpeg_finish_decompress(&cinfo);
    jpeg_destroy_decompress(&cinfo);
    return buffer;
}

uint8_t* save_jpeg_rgb(uint8_t* rgb_buffer, int width, int height, int quality, unsigned long* out_size) {
    struct jpeg_compress_struct cinfo;
    struct jpeg_error_mgr jerr;

    uint8_t* outbuffer = NULL;  // jpeg_mem_destがmallocしてくれる
    *out_size = 0;

    cinfo.err = jpeg_std_error(&jerr);
    jpeg_create_compress(&cinfo);

    jpeg_mem_dest(&cinfo, &outbuffer, out_size);

    cinfo.image_width = width;
    cinfo.image_height = height;
    cinfo.input_components = 3;
    cinfo.in_color_space = JCS_RGB;

    jpeg_set_defaults(&cinfo);
    jpeg_set_quality(&cinfo, quality, TRUE);

    jpeg_start_compress(&cinfo, TRUE);
    JSAMPROW row_pointer[1];
    int row_stride = width*3;

    while (cinfo.next_scanline < cinfo.image_height) {
        row_pointer[0] = &rgb_buffer[cinfo.next_scanline * row_stride];
        jpeg_write_scanlines(&cinfo, row_pointer, 1);
    }

    jpeg_finish_compress(&cinfo);
    jpeg_destroy_compress(&cinfo);

    return outbuffer;
}

uint8_t* save_jpeg_gray(uint8_t* gray_buffer, int width, int height, int quality, unsigned long* out_size) {
    struct jpeg_compress_struct cinfo;
    struct jpeg_error_mgr jerr;

    uint8_t* outbuffer = NULL;  // jpeg_mem_destがmallocしてくれる
    *out_size = 0;

    cinfo.err = jpeg_std_error(&jerr);
    jpeg_create_compress(&cinfo);

    jpeg_mem_dest(&cinfo, &outbuffer, out_size);

    cinfo.image_width = width;
    cinfo.image_height = height;
    cinfo.input_components = 1;
    cinfo.in_color_space = JCS_GRAYSCALE;

    jpeg_set_defaults(&cinfo);
    jpeg_set_quality(&cinfo, quality, TRUE);

    jpeg_start_compress(&cinfo, TRUE);
    JSAMPROW row_pointer[1];
    int row_stride = width;

    while (cinfo.next_scanline < cinfo.image_height) {
        row_pointer[0] = &gray_buffer[cinfo.next_scanline * row_stride];
        jpeg_write_scanlines(&cinfo, row_pointer, 1);
    }

    jpeg_finish_compress(&cinfo);
    jpeg_destroy_compress(&cinfo);

    return outbuffer;
}

// 90度時計回りに回転する
EMSCRIPTEN_KEEPALIVE
void rotate(uint8_t* input_buf, int input_size) {
    int width, height;
    uint8_t* src = load_jpeg_from_memory(input_buf, input_size, &width, &height);
    if (!src) {
        fprintf(stderr, "JPEGの読み込みに失敗しました\n");
        return;
    }
    uint8_t* dst = malloc(width * height * 3);
    int x, y, c;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            for (c = 0; c < 3; c++) {
                dst[(x * height + (height - 1 - y)) * 3 + c] = src[(y * width + x) * 3 + c];
            }
        }
    }
    output_buf = save_jpeg_rgb(dst, height, width, 90, &output_size);
    free(dst);
    free(src);
}

// グレースケールにする
EMSCRIPTEN_KEEPALIVE
void gray(uint8_t* input_buf, int input_size) {
    int width, height;
    uint8_t* src = load_jpeg_from_memory(input_buf, input_size, &width, &height);
    if (!src) {
        fprintf(stderr, "JPEGの読み込みに失敗しました\n");
        return;
    }
    
    uint8_t* dst = malloc(width * height);
    for (int i = 0; i < width * height; i++) {
        uint8_t r = src[i * 3 + 0];
        uint8_t g = src[i * 3 + 1];
        uint8_t b = src[i * 3 + 2];
        dst[i] = (uint8_t)(0.299 * r + 0.587 * g + 0.114 * b);
    }
    
    output_buf = save_jpeg_gray(dst, width, height, 90, &output_size);
    free(dst);
    free(src);
}
