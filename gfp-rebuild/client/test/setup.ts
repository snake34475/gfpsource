// 测试环境设置
import { afterEach, vi } from 'vitest';
import { cleanup } from '@testing-library/react';

// 每次测试后清理
afterEach(() => {
  cleanup();
});

// 全局 mock
vi.mock('ws', async () => {
  return {
    WebSocket: vi.fn().mockImplementation(() => ({
      onopen: null,
      onclose: null,
      onmessage: null,
      onerror: null,
      send: vi.fn(),
      close: vi.fn(),
    })),
  };
});