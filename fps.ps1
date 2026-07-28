export default {
  async fetch(request, env, ctx) {
    // 1. รายชื่อคีย์ทั้งหมดของคุณ
    const ALLOWED_KEYS = {
      "TEST-123": "", 
      "ADMIN-TEST": ""
    };
    
    // 2. ใส่ GitHub Token และ URL ของไฟล์ main.ps1 ให้ถูกต้อง
    const GITHUB_TOKEN = "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";
    const REPO_URL = "https://raw.githubusercontent.com/natchanam18-debug/aaa/refs/heads/main/aa.ps1";

    // ดักจับ Options requests (CORS)
    if (request.method === "OPTIONS") {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type",
        }
      });
    }

    if (request.method !== "POST") {
      return new Response("Method Not Allowed", { status: 405 });
    }

    try {
      const body = await request.json();
      const userKey = body.key ? body.key.trim() : "";
      const userHwid = body.hwid ? body.hwid.trim() : "";

      // ตรวจสอบว่ามีคีย์นี้อยู่ในระบบหรือไม่
      if (!(userKey in ALLOWED_KEYS)) {
        return new Response("❌ คีย์ไม่ถูกต้อง!", { status: 403 });
      }

      if (!userHwid) {
        return new Response("❌ ไม่พบข้อมูลฮาร์ดแวร์เครื่อง (HWID)", { status: 400 });
      }

      // ตรวจสอบ HWID ใน Cloudflare KV
      // (ต้องผูก KV Namespace ไว้กับตัวแปรชื่อ MY_KV)
      if (env.MY_KV) {
        const registeredHwid = await env.MY_KV.get(userKey);

        if (registeredHwid) {
          // ถ้ามี HWID บันทึกไว้แล้ว แต่ไม่ตรงกับเครื่องที่ส่งมาแปลว่าแอบเอาคีย์คนอื่นมาใช้
          if (registeredHwid !== userHwid) {
            return new Response("❌ คีย์นี้ถูกใช้งานผูกติดกับคอมพิวเตอร์เครื่องอื่นไปแล้ว!", { status: 403 });
          }
        } else {
          // ถ้ายังไม่เคยถูกใช้งาน ให้บันทึก HWID นี้ล็อกไว้กับคีย์ทันที
          await env.MY_KV.put(userKey, userHwid);
        }
      }

      // ดึงโค้ดจาก GitHub
      const githubResponse = await fetch(REPO_URL, {
        method: "GET",
        headers: {
          "Authorization": `Bearer ${GITHUB_TOKEN}`,
          "User-Agent": "Cloudflare-Worker",
          "X-GitHub-Api-Version": "2022-11-28"
        }
      });

      if (!githubResponse.ok) {
        return new Response("❌ ดึงโค้ดจาก GitHub ไม่สำเร็จ", { status: 500 });
      }

      const securePayload = await githubResponse.text();
      
      // ส่งซอร์สโค้ดกลับไปรันที่เครื่องลูกค้า
      return new Response(securePayload, {
        status: 200,
        headers: {
          "Content-Type": "text/plain; charset=utf-8",
          "Access-Control-Allow-Origin": "*"
        }
      });

    } catch (err) {
      return new Response("❌ เซิร์ฟเวอร์ Workers เกิดข้อผิดพลาด: " + err.message, { status: 500 });
    }
  }
};
