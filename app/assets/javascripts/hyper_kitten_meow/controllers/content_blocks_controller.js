import { Controller } from "@hotwired/stimulus"
import * as quill from "quill";

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
    if (this.activeBlocksFieldsTarget) {
      this._setSelectedTemplateValue();
      this._setupQuillEditors();
    } else {
      this.updateContentBlockFields();
    }
  }

  updateContentBlockFields() {
    this._setSelectedTemplateValue();
    this._clearActiveBlocksFields();
    if (this.blocksValue[this.selectedTemplateValue].hasOwnProperty("cachedFields")) {
      this.activeBlocksFieldsTarget.innerHTML = this.blocksValue[this.selectedTemplateValue]["cachedFields"];
    } else {
      this._blocksForSelectedTemplate().forEach((blockInfo) => {
        const content = this._buildContentBlockFields(blockInfo);
        this.activeBlocksFieldsTarget.innerHTML += content;
      });
      this._setupQuillEditors();
    }
  }

  _setSelectedTemplateValue() {
    this.selectedTemplateValue = this.templateFieldTarget.value;
  }

  _buildContentBlockFields(blockInfo) {
    const fields  = this.contentBlockFieldTemplateTarget
    const fieldsContainer = fields.content.querySelector(".quill-fields-container");
    const titleElement = fields.content.querySelector("h4.content-block-name");
    const input = fields.content.querySelector("input.content-block-name-field");
    input.setAttribute("value", blockInfo.value);
    titleElement.textContent = blockInfo.title;
    fieldsContainer.dataset.blockName = blockInfo.value;
    return fields.innerHTML.replace(/NEW_RECORD/g, this._randomId());
  }

  _setupQuillEditors() {
    const form = this.element.closest("form");

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
        console.log(hiddenInput.value);
        quillEditor.clipboard.dangerouslyPasteHTML(hiddenInput.value);
        this._cacheFieldContent(quillEditor.getContents(), fieldsContainer.dataset.blockName);
      } else  {
        const cachedContent = this.blocksValue[this.selectedTemplateValue].blocksInfo.find((block) => block.value === fieldsContainer.dataset.blockName).cachedFields;
        if (cachedContent) { quillEditor.setContents(cachedContent); }
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
    return this.blocksValue[this.templateFieldTarget.value]["blocksInfo"];
  }

  _cacheFieldContent(currentContents, blockValue) {
    const newBlocksValue = this.blocksValue;
    newBlocksValue[this.selectedTemplateValue].blocksInfo.forEach((block) => {
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
