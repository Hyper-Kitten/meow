import { Controller } from "@hotwired/stimulus"
import Quill from "quill";

export default class extends Controller {
  static targets = [
    "contentBlocks",
    "contentBlockFieldTemplate",
    "templateField",
    "activeBlocksFields",
    "quillFieldsContainer",
    "hiddenQuillInput"
  ];

  static values = { blocks: Object, selectedTemplate: String };

  connect() {
    this._setSelectedTemplateValue();

    // Check if we have valid content blocks (ones with proper names)
    const hasValidContentBlocks = this._hasValidContentBlocks();

    if (hasValidContentBlocks) {
      // Page has existing content blocks with names, just set up Quill editors
      this._setupQuillEditors();
    } else {
      // No valid content blocks, populate from template
      this.updateContentBlockFields();
    }
  }

  _hasValidContentBlocks() {
    if (!this.hasActiveBlocksFieldsTarget) return false;

    // Check if any content block has a non-empty name
    const nameFields = this.activeBlocksFieldsTarget.querySelectorAll('input.content-block-name-field');
    return Array.from(nameFields).some(field => field.value && field.value.trim() !== '');
  }

  updateContentBlockFields() {
    this._setSelectedTemplateValue();
    this._clearActiveBlocksFields();

    const templateData = this.blocksValue[this.selectedTemplateValue];
    if (!templateData) {
      return;
    }

    if (templateData.hasOwnProperty("cachedFields")) {
      this.activeBlocksFieldsTarget.innerHTML = templateData["cachedFields"];
    } else {
      this._blocksForSelectedTemplate().forEach((blockInfo) => {
        const content = this._buildContentBlockFields(blockInfo);
        this.activeBlocksFieldsTarget.innerHTML += content;
      });
      this._setupQuillEditors();
    }
  }

  _setSelectedTemplateValue() {
    const fieldValue = this.templateFieldTarget.value;
    // Use the field value if it exists in blocksValue, otherwise fall back to first available template
    if (fieldValue && this.blocksValue[fieldValue]) {
      this.selectedTemplateValue = fieldValue;
    } else {
      this.selectedTemplateValue = Object.keys(this.blocksValue)[0];
    }
  }

  _buildContentBlockFields(blockInfo) {
    const template = this.contentBlockFieldTemplateTarget;
    // Clone the template content so modifications don't affect the original
    const clone = template.content.cloneNode(true);

    const fieldsContainer = clone.querySelector(".quill-fields-container");
    const titleElement = clone.querySelector("h4.content-block-name");
    const input = clone.querySelector("input.content-block-name-field");

    input.setAttribute("value", blockInfo.value);
    titleElement.textContent = blockInfo.title;
    fieldsContainer.dataset.blockName = blockInfo.value;

    // Serialize the clone to HTML
    const temp = document.createElement('div');
    temp.appendChild(clone);
    return temp.innerHTML.replace(/NEW_RECORD/g, this._randomId());
  }

  _setupQuillEditors() {
    this.quillFieldsContainerTargets.forEach((fieldsContainer) => {
      // Data attributes
      const quillContainer = fieldsContainer.querySelector(".quill-container");
      const hiddenInput = fieldsContainer.querySelector("input[type='hidden']");

      const quillEditor = new Quill(quillContainer, {
        modules: {
          toolbar: [
            [{ header: [1, 2, 3, 4, 5, false] }],
            [{ color: [] }],
            ["bold", "italic", "underline", "strike", "code"],
            ["blockquote", "code-block"],
            [{ list: "ordered" }, { list: "bullet" }],
            ["link"],
            ["clean"],
          ],
        },
        theme: "snow",
      });
      if (hiddenInput.value) {
        quillEditor.clipboard.dangerouslyPasteHTML(hiddenInput.value);
        this._cacheFieldContent(quillEditor.getContents(), fieldsContainer.dataset.blockName);
      } else {
        const templateData = this.blocksValue[this.selectedTemplateValue];
        const blockInfo = templateData?.blocksInfo?.find((block) => block.value === fieldsContainer.dataset.blockName);
        if (blockInfo?.cachedFields) { quillEditor.setContents(blockInfo.cachedFields); }
      }
      quillEditor.on('text-change', () => {
        const currentContents = quillEditor.getContents();
        const block = fieldsContainer.dataset.blockName;
        this._cacheFieldContent(currentContents, block);
        hiddenInput.value = quillEditor.getSemanticHTML();
      });
    });
  }

  _clearActiveBlocksFields() {
    this.activeBlocksFieldsTarget.innerHTML = "";
  }

  _blocksForSelectedTemplate() {
    return this.blocksValue[this.selectedTemplateValue]?.blocksInfo || [];
  }

  _cacheFieldContent(currentContents, blockValue) {
    const newBlocksValue = this.blocksValue;
    const templateData = newBlocksValue[this.selectedTemplateValue];
    if (!templateData?.blocksInfo) return;

    templateData.blocksInfo.forEach((block) => {
      if (block.value === blockValue) {
        block.cachedFields = currentContents;
      }
    });
    this.blocksValue = newBlocksValue;
  }

  _randomId() {
    return Math.floor(Math.random() * 100000000);
  }
}
