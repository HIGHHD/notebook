## PDF合并

```python
import os
from PyPDF2 import PdfFileMerger

target_path = '/home/workspace/tools'
pdf_lst = [f for f in os.listdir(target_path) if f.endswith('.pdf')]
pdf_lst = [os.path.join(target_path, filename) for filename in pdf_lst]

file_merger = PdfFileMerger()
for pdf in pdf_lst:
    file_merger.append(pdf)     # 合并pdf文件

file_merger.write("/home/workspace/tools/merge.pdf")
```

