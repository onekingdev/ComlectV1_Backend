<template lang="pug">
  .stars-rating
    .stars-rating_filled-line(:style="filledLineStyles")
    .stars-rating_item(v-for="idx in totalStars" :key="idx")
</template>

<script>
/**
*  Render rating by SVG stars
*  filled-line is a yellow line that stays behind SVG clipped stars and it has per cent width
*  @see {@link https://css-tricks.com/five-methods-for-five-star-ratings/}
*/

export default {
  name: 'StarsRating',
  props: {
    totalStars: {
      type: Number,
      default: 5
    },
    rate: {
      type: Number,
      default: 0
    },
  },
  data () {
    return {
      // percent of yellow lines width
      widthOfFilledLine: 0
    }
  },
  computed: {
    // If we don't do this, then we have
    // different animation speed and one star will
    // be filled as slow as all 5 stars
    transitionDuration () {
      return this.rate / this.totalStars
    },
    // styles object for yellow filled line
    filledLineStyles () {
      return {
        width: this.widthOfFilledLine + '%',
        transitionDuration: this.transitionDuration + 's'
      }
    }
  },
  mounted () {
    // special for filling animation after mountig
    // I'm not sure about this. In Vue Docs is recommended
    // to use GSAP, but I didn't want to load any library yet
    window.setTimeout(() => {
      this.widthOfFilledLine = (this.rate / this.totalStars * 100).toFixed(2)
    }, 300)
  }
}
</script>

<style scoped>
.stars-rating {
  display: flex;
  position: relative;
  background-color: #F3F6F9;
}
.stars-rating_filled-line {
  width: 0;
  height: 100%;
  position: absolute;
  left: 0;
  top: 0;
  background-color: #FFC900;
  transition: width .3s ease-out;
}
.stars-rating_item {
  position: relative;
  width: 20px;
  height: 20px;
  margin-right: 5px;
  z-index: 2;
  background-image: url(../../assets/star.svg); /* probably, the best way is to use "<svg use=''>". May be I remake it later */
  background-size: 105%;
}
.stars-rating_item::after {
  content: '';
  display: block;
  position: absolute;
  width: 5px;
  height: 100%;
  right: -5px;
  top: 0;
  background-color: #fff;
}
.stars-rating_item:last-child {
  margin-right: 0;
}
.stars-rating_item >>> svg {
  fill: #fff;
}
</style>