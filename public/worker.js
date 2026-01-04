// wasmを使った画像編集
onmessage = async function(e) {
    importScripts('test.js');  // wasm読み込み
    const { imgUrl, ops } = e.data;
    const response = await fetch(imgUrl);
    const arrayBuffer = await response.arrayBuffer();
    const data = new Uint8Array(arrayBuffer);
    const size = data.length;
    
    // ヒープにメモリを確保してJPEGバイナリを書き込む
    const ptr = Module._malloc(size);
    Module.HEAPU8.set(data, ptr);
    
    // gray(uint8_t* input_buf, int input_size) を呼び出す
    if (ops === 0) {
    Module._gray(ptr, size);
    } else {
    Module._rotate(ptr, size);
    }
    const outPtr = Module._get_result_ptr();
    const outSize = Module._get_result_size();
    
    // HEAPU8から出力バッファを取り出す
    const buffer = Module.HEAPU8.slice(outPtr, outPtr + outSize);
    
    // メモリ解放
    Module._free(ptr);
    Module._free(outPtr);
    this.postMessage({buffer: buffer}, [buffer.buffer]);
}