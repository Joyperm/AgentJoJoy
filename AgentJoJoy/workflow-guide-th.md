# คู่มือการเริ่มต้นใช้งาน — AgentJoJoy

ยินดีต้อนรับสู่ **AgentJoJoy** นี่คือ workspace wrapper สำหรับทำงานกับ
AI assistants ทั้งกับโปรเจกต์ใหม่และ repo ที่มีอยู่แล้ว โดยแยกบริบทส่วนตัว
ของ AI ออกจากโค้ดของโปรเจกต์

---

## 1. เริ่มตรงนี้

สำหรับ workspace ใหม่ ให้ใช้ปุ่ม **Use this template** บน GitHub:

1. สร้าง repository ใหม่จาก AgentJoJoy template
2. clone repository ใหม่นั้นลงเครื่อง
3. เปิด Claude Code, Codex, Cursor หรือ Gemini ที่ workspace root
4. บอก AI ให้อ่าน `CLAUDE.md` / `AGENTS.md` แล้วเริ่ม onboarding
5. เลือก **New Project**, **Existing Project** หรือ **Skip** เมื่อ AI ถาม

ถ้าคุณมี AgentJoJoy workspace อยู่แล้ว อย่าสร้าง template copy ใหม่เพื่ออัปเกรด
ให้ใช้ upgrade prompt ใน `README.md` แทน เพื่อรักษา project notes,
decisions, technical precedents และ custom skills ของคุณไว้

---

## 2. แนวคิดหลัก

AgentJoJoy ใช้แนวคิด **wrapper workspace**:

```text
WorkspaceRoot/
├─ CLAUDE.md / AGENTS.md          # จุดเริ่มต้นของ AI
├─ progress-tracker.md            # ตัวติดตามงานรายวัน
├─ AgentJoJoy/                    # บริบทและกฎส่วนตัวของ AI
│  ├─ agent-context/              # metadata และ notes ของโปรเจกต์
│  ├─ agent-rules/                # workflow และ safety rules
│  ├─ agent-tools/                # helper scripts แบบ local
│  ├─ skills/                     # portable และ project skills
│  ├─ workflow-guide.md           # คู่มืออังกฤษ
│  └─ workflow-guide-th.md        # คู่มือไทย
├─ TeamRepo/                      # repo โปรเจกต์ที่มีอยู่แล้ว (ถ้ามี)
└─ worktree-task-a/               # worktree สำหรับงานเฉพาะ (ถ้ามี)
```

ขอบเขตสำคัญคือ:

- บริบทส่วนตัวของ AI อยู่ใน `AgentJoJoy/` และไฟล์ระดับ wrapper
- โค้ดโปรเจกต์อยู่ใน project repo หรือ task worktree
- commit ของทีม/โปรเจกต์ไม่ควรรวม personal AI operating layer

---

## 3. Onboarding Paths

เมื่อเริ่ม AI session ใน workspace ใหม่ AI จะตรวจสถานะ workspace แล้วถามว่าจะไปทางไหน

### New Project

เลือกเมื่อเริ่มโปรเจกต์ใหม่จากศูนย์ AI จะช่วยถามเป้าหมาย เสนอโครงสร้าง folder
และเติม context เฉพาะส่วนที่คุณอนุมัติ

### Existing Project

เลือกเมื่อต้องการ wrap repo, ชุดเอกสาร หรือ research folder ที่มีอยู่แล้ว
AI จะ scan แบบ read-only ก่อน อธิบาย wrapper model และขออนุมัติก่อน move,
clone, link หรือเขียนไฟล์ใด ๆ

สำหรับ team repo ระบบจะแนะนำให้ใช้ภาษาอังกฤษเป็นค่าเริ่มต้น เพราะ IDE logs,
screenshare, transcript ที่ผูกกับ PR หรือ audit export อาจถูกเห็นโดยทีม

### Skip

เลือกเมื่ออยากถามคำถามตรง ๆ โดยยังไม่ตั้งค่า workspace AI จะไม่แก้ template files

---

## 4. Safety Rules

AI อ่านไฟล์และรันคำสั่งตรวจสอบแบบ read-only ได้ แต่ต้องขอก่อนทำสิ่งที่เปลี่ยน state
เช่น:

- commit, push, pull, branch switch, merge, rebase, tag หรือ PR actions
- install dependencies หรือเปลี่ยน lockfile
- ลบ/เขียนทับไฟล์แบบเสี่ยง
- migrations, deployments, environment writes หรือ scripts ที่ side effect ไม่ชัด
- เริ่ม runtime ที่รันยาว เว้นแต่ project ระบุว่าปลอดภัย

Secrets ควรอยู่ใน project `.env`, secret manager หรือ CI variables
ห้าม copy credentials เข้า `AgentJoJoy/`

---

## 5. Options ที่ใช้บ่อย

### Distraction-Free Mode

ระหว่าง onboarding คุณสามารถให้ AI ตั้งค่า VS Code เพื่อซ่อนไฟล์ภายในของ
AgentJoJoy จาก Explorer sidebar ได้ AI จะสร้างหรือแก้ `.vscode/settings.json`
แบบระวัง โดยไม่ทับ editor settings อื่นของคุณ

### Technical Precedents
 
ไฟล์ Markdown แบบแบน (`AgentJoJoy/agent-context/technical-precedents.md`) ภายใต้ `agent-context/` จะถูกใช้เพื่อบันทึกข้อเท็จจริงทางเทคนิค ทางออกสำหรับการขัดข้อง และแนวทางแก้ไขที่ผ่านการพิสูจน์แล้ว AI จะทำการบันทึกปัญหาและทางออกลงในนี้โดยอัตโนมัติ เพื่อให้เอเจนต์ในเซสชันถัดไปหลีกเลี่ยงและข้ามผ่านจุดติดขัดทางเทคนิคเดิมได้ทันที เป็นไฟล์ที่โปร่งใส เปิดอ่านและแก้ไขได้ง่ายโดยมนุษย์

### AI-NO-OVERWRITE Block Protection

เพื่อปกป้องคำสั่งการตั้งค่าส่วนบุคคล หรือส่วนของโค้ดในโปรเจกต์ไม่ให้ AI แก้ไขหรือสูญหายระหว่างการอัปเกรดเทมเพลต คุณสามารถนำแท็ก HTML Comment ไปครอบเนื้อหาเหล่านั้นได้:

```html
<!-- AGENTJOJOY:AI-NO-OVERWRITE BEGIN -->
... กฎเฉพาะตัว, การตั้งค่า หรือบันทึกของคุณ ...
<!-- AGENTJOJOY:AI-NO-OVERWRITE END -->
```

เนื้อหาหรือการตั้งค่าใดๆ ที่อยู่ภายใต้แท็กนี้ในทุกไฟล์ของระบบจะถือเป็นพื้นที่ที่ห้ามแก้ไข (Read-only) โดยเด็ดขาด โดย AI ในเซสชันงานทั่วไปและระบบอัปเกรดจะไม่สามารถลบหรือดัดแปลงเนื้อหาเหล่านั้นได้

### Test-First / TDD Preference

ระหว่าง onboarding คุณบอก AI ได้ว่าต้องการ workflow แบบ test-first หรือไม่
เมื่อเปิดใช้หรือเหมาะสม AI ควรเขียนหรือ stub test ที่ reproduce failure
ก่อน implementation หรือ debugging

### Junction Link Model

สำหรับ runtime environment ที่บังคับให้โค้ดต้องอยู่ path เฉพาะ AgentJoJoy รองรับ
Windows Directory Junction model ได้ โค้ดอยู่ใต้ wrapper แต่ external runtime path
ชี้มาหาด้วย junction link AI ต้องถามก่อนสร้างหรือลบ link เสมอ

---

## 6. Portable Skills

AgentJoJoy มี core skills สองกลุ่ม:

- `agentjojoy-core-practices` — debugging, review, post-mortems และ stakeholder updates
- `grill-me` — design interview แบบถามทีละคำถามสำหรับแผนที่ยังไม่ชัด workflow ใหม่
  และ architecture decisions

Project-specific skills สามารถอยู่ใต้ `AgentJoJoy/skills/` ได้เช่นกัน
ระหว่าง upgrade custom skills ถือเป็น user-owned และควรถูก preserve

> **หมายเหตุเรื่องการเรียกใช้:** AgentJoJoy skills ไม่ขึ้นใน `/` command palette
> เพราะ AI ค้นพบ skills โดยการอ่าน workspace แล้วเทียบ description ของ skill
> กับ request ของคุณ — บอกสิ่งที่ต้องการเป็นภาษาธรรมดา AI จะหยิบ skill
> ที่เหมาะสมจาก `AgentJoJoy/skills/` มาใช้เอง
>
> **การเพิ่ม skill = drag-and-drop**: วาง folder ที่มี `SKILL.md` ลงใน
> `AgentJoJoy/skills/` AI จะเห็นผ่าน `git status` ใน interaction ถัดไป
> ไม่ต้อง install ไม่ต้อง restart ไม่ต้อง update registry (skill ที่ AI
> สร้างเองจาก pattern ที่สังเกตเห็นก็ใช้กลไกนี้เหมือนกัน — เพราะ AI
> เป็นทั้งคนสร้างและคนค้นพบ)

---

## 7. Upgrading

สำหรับ AgentJoJoy workspace ที่มีอยู่แล้ว ให้อัปเกรดด้วย canonical prompt ใน `README.md`

Upgrade flow จะเทียบ workspace ของคุณกับ release tag เฉพาะ และใช้
`AgentJoJoy/agent-rules/file-ownership.md`:

- template-owned files อัปเดตได้หลังคุณอนุมัติ
- mixed files จะ preserve ค่าที่คุณกรอกไว้ แล้วค่อยอัปเดตโครงสร้าง
- user-owned files จะไม่ถูก overwrite

อย่าใช้ปุ่ม GitHub **Use this template** เพื่ออัปเกรด workspace เดิม
ปุ่มนั้นใช้สำหรับสร้าง workspace ใหม่

---

## 8. Cross-Platform Note

AgentJoJoy เป็น workflow แบบเอกสาร จึงใช้ได้บน Windows, macOS หรือ Linux
แต่ helper scripts ที่ bundle มาตอนนี้เป็น PowerShell-first และทดสอบบน Windows
เป็นหลัก หากใช้ macOS/Linux ให้ขอ AI แปล helper commands เป็น shell ของเครื่อง
และอนุมัติคำสั่งที่เปลี่ยน state ก่อนรันเสมอ
