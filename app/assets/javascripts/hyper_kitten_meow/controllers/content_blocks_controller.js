import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "contentBlocks",
    "contentBlockFieldTemplate",
    "templateField",
    "activeBlocksFields",
    "blockFieldsContainer"
  ];

  static values = { blocks: Object, selectedTemplate: String };

  connect() {
    this._setSelectedTemplateValue();

    // Server-rendered editors upgrade themselves; only build fields when the
    // page has no named content blocks yet.
    if (!this._hasValidContentBlocks()) {
      this.updateContentBlockFields();
    }
  }

  _hasValidContentBlocks() {
    if (!this.hasActiveBlocksFieldsTarget) return false;

    const nameFields = this.activeBlocksFieldsTarget.querySelectorAll('input.content-block-name-field');
    return Array.from(nameFields).some(field => field.value && field.value.trim() !== '');
  }

  updateContentBlockFields() {
    this._cacheCurrentEditors();
    this._setSelectedTemplateValue();
    this.activeBlocksFieldsTarget.innerHTML = "";

    this._blocksForSelectedTemplate().forEach((blockInfo) => {
      this.activeBlocksFieldsTarget.appendChild(this._buildContentBlockFields(blockInfo));
    });
  }

  _setSelectedTemplateValue() {
    const fieldValue = this.templateFieldTarget.value;
    if (fieldValue && this.blocksValue[fieldValue]) {
      this.selectedTemplateValue = fieldValue;
    } else {
      this.selectedTemplateValue = Object.keys(this.blocksValue)[0];
    }
  }

  _buildContentBlockFields(blockInfo) {
    const fragment = this.contentBlockFieldTemplateTarget.content.cloneNode(true);

    const fieldsContainer = fragment.querySelector(".lexxy-fields-container");
    const titleElement = fragment.querySelector("h4.content-block-name");
    const nameInput = fragment.querySelector("input.content-block-name-field");

    nameInput.setAttribute("value", blockInfo.value);
    titleElement.textContent = blockInfo.title;
    fieldsContainer.dataset.blockName = blockInfo.value;

    // Give this set of fields a unique index so nested attributes don't collide.
    const newId = this._randomId();
    fragment.querySelectorAll("*").forEach((element) => {
      for (const attribute of element.attributes) {
        if (attribute.value.includes("NEW_RECORD")) {
          element.setAttribute(attribute.name, attribute.value.replaceAll("NEW_RECORD", newId));
        }
      }
    });

    // Restore previously typed content. The editor reads this attribute when it
    // upgrades on insertion, so it must be set while the fragment is detached.
    if (blockInfo.cachedHtml != null) {
      fragment.querySelector("lexxy-editor")?.setAttribute("value", blockInfo.cachedHtml);
    }

    return fragment;
  }

  _cacheCurrentEditors() {
    const newBlocksValue = this.blocksValue;
    const templateData = newBlocksValue[this.selectedTemplateValue];
    if (!templateData?.blocksInfo) return;

    this.blockFieldsContainerTargets.forEach((fieldsContainer) => {
      const editor = fieldsContainer.querySelector("lexxy-editor");
      const block = templateData.blocksInfo.find((b) => b.value === fieldsContainer.dataset.blockName);
      if (editor && block) block.cachedHtml = editor.value;
    });

    this.blocksValue = newBlocksValue;
  }

  _blocksForSelectedTemplate() {
    return this.blocksValue[this.selectedTemplateValue]?.blocksInfo || [];
  }

  _randomId() {
    return Math.floor(Math.random() * 100000000);
  }
}
