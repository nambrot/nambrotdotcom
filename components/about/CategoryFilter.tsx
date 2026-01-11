'use client'

interface CategoryFilterProps {
  selectedCategories: string[]
  onCategoryChange: (categories: string[]) => void
  importanceLevel: number
  onImportanceChange: (level: number) => void
}

export default function CategoryFilter({
  selectedCategories,
  onCategoryChange,
  importanceLevel,
  onImportanceChange,
}: CategoryFilterProps) {
  const toggleCategory = (category: string) => {
    if (selectedCategories.includes(category)) {
      onCategoryChange(selectedCategories.filter(c => c !== category))
    } else {
      onCategoryChange([...selectedCategories, category])
    }
  }

  return (
    <div id="category-picker-box">
      <div>
        <p>Choose which aspects of my personality you want to learn more about</p>
        <form id="category-picker">
          <label id="checkbox2">
            <input
              type="checkbox"
              name="category picker"
              value="coder"
              checked={selectedCategories.includes('coder')}
              onChange={() => toggleCategory('coder')}
            />
            <div>
              <span className="image"></span>
              <span className="text">Code</span>
            </div>
          </label>

          <label id="checkbox3">
            <input
              type="checkbox"
              name="category picker"
              value="traveler"
              checked={selectedCategories.includes('traveler')}
              onChange={() => toggleCategory('traveler')}
            />
            <div>
              <span className="image"></span>
              <span className="text">Travel</span>
            </div>
          </label>

          <label id="checkbox4">
            <input
              type="checkbox"
              name="category picker"
              value="job"
              checked={selectedCategories.includes('job')}
              onChange={() => toggleCategory('job')}
            />
            <div>
              <span className="image"></span>
              <span className="text">Career</span>
            </div>
          </label>
        </form>
      </div>

      <div>
        <p>How much detail you want to see</p>
        <div id="importance-slider-left-border">Overview</div>
        <div id="importance-slider-container">
          <input
            type="range"
            id="importance-slider"
            min="2"
            max="3"
            step="1"
            value={importanceLevel}
            onChange={(e) => onImportanceChange(parseInt(e.target.value, 10))}
            style={{ width: '100%' }}
          />
        </div>
        <div id="importance-slider-right-border">Detail</div>
      </div>
    </div>
  )
}
